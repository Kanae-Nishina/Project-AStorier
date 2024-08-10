require 'mini_magick'

class Api::V1::PostsController < Api::V1::BasesController
  skip_before_action :authenticate_api_v1_user!, only: %i[index show]
  before_action :set_post, only: %i[update destroy]

  def index
    posts = Post.includes(:postable, :user, postable: :illust_attachments).where(publish_state: 'all_publish').order(published_at: :desc).limit(24)
    posts_json = posts.map do |post|
      content = nil
      if post.illust?
        # 一覧では最初の画像のみ表示
        content = url_for(post.postable.get_first_image)
      end
      post.as_custom_index_json(content)
    end
    render json: posts_json, status: :ok
  end

  def show
    begin
      if params[:id].length != 22
        raise ActiveRecord::RecordInvalid
      end

      post = Post.includes(:postable, :tags, :synalios, :user, postable: :illust_attachments).find_by_short_uuid(params[:id])

      if post.nil? || !post.publishable?(current_api_v1_user)
        raise ActiveRecord::RecordNotFound
      end

      content = []
      if post.illust?
        post.postable.illust_attachments.each do |attachment|
          content << url_for(attachment.image)
        end
      end

      render json: post.as_custom_show_json(content), status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: 'Invalid UUID' }, status: :not_found
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Not Found' }, status: :not_found
    rescue => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace.join("\n"))
      render json: { error: e.message }, status: :internal_server_error
      end
  end

  def create
    Post.transaction do
      begin
        default_params = post_params.except(:postable_attributes, :tags, :synalios, :game_systems, :illust_attachments)
        post = current_api_v1_user.posts.build(default_params)

        # 下書き以外は投稿日時保存
        post.published_at = Time.now unless post.draft?

        # 投稿タイプに応じたクラス
        postable_type = Post.initialize_postable(post_params[:postable_type])
        # 投稿タイプのクラスをインスタンス
        post.postable = postable_type.create!

        # イラストの場合
        if post.illust? && !post.postable.illust_images_create!(post_params[:postable_attributes])
          raise StandardError, "Failed to create illust images"
        end
        # 保存
        post.save!

        # タグの登録
        post.create_tags(post_params[:tags])
        # シナリオ名の登録
        post.create_synalios(post_params[:synalios])
        # システムの登録
        post.create_game_systems(post_params[:game_systems])

        render json: { uuid: post.short_uuid }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Validation failed: #{e.record.errors.full_messages.join(", ")}")
        render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
        render json: { error: e.message }, status: :bad_request
        raise ActiveRecord::Rollback
      end
    end
  end

  def edit
    if params[:post_id].length != 22
      render json: { error: 'Not Found' }, status: :not_found and return
    end

    post = current_api_v1_user.posts.includes(:postable, :tags, :synalios, postable: :illust_attachments).find_by_short_uuid(params[:post_id])

    if post.nil? || post.postable.nil?
      render json: { error: 'Not Found' }, status: :not_found and return
    end

    content = []
    if post.illust?
      post.postable.illust_attachments.each do |attachment|
        content << {
          body: url_for(attachment.image),
          position: attachment.position
        }
      end
    end

    render json: post.as_custom_edit_json(content), status: :ok
  end

  def update
    Post.transaction do
      begin
        # 投稿データのメインコンテンツの更新が可能か
        if @post.main_content_updatable?
          # イラスト
          if @post.illust? && !@post.postable.illust_images_update!(post_params[:postable_attributes])
            raise "画像の保存に失敗しました"
          end
        end

        # 公開設定で初公開のときは公開日時を設定
        @post.set_published_at(post_params[:publish_state])

        # タグの更新
        @post.update_tags(post_params[:tags])

        # シナリオ名の更新
        @post.update_synalios(post_params[:synalios])

        # システムの更新
        @post.update_game_systems(post_params[:game_systems])

        if @post.update!(post_params.except(:postable_attributes, :tags, :synalios, :game_systems))
          render json: { uuid: @post.short_uuid }, status: :ok
        else
          render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
        end
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.join("\n"))
        render json: { error: e.message }, status: :bad_request
      end
    end
  end

  def destroy
    begin
      @post.destroy!
      render json: { title: @post.title }, status: :ok
    rescue => e
      logger.error(e.message)
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :caption, :publish_state, :postable_type, postable_attributes: [:body, :position], tags: [], synalios: [], game_systems: [])
  end

  def set_post
    @post = current_api_v1_user.posts.find_by_short_uuid(params[:id])
  end
end
