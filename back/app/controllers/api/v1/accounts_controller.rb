class Api::V1::AccountsController < Api::V1::BasesController
  def show
    # 通知設定取得
    notices = current_api_v1_user.user_notices.map do |user_notice|
      # データ部分をシリアライズして取得
      serialized_notice = NoticeSerializer.new(user_notice.notice).serializable_hash[:data]
      {
        # 通知の種類をキーとしてデータの部分とidをマージ
        user_notice.notice_kind => serialized_notice[:attributes].merge(id: serialized_notice[:id])
      }
    end.reduce({}, :merge) # マージして1つのハッシュにする

    account = current_api_v1_user.authentications.map do |authentication|
      if(authentication.provider == 'email')
        {
          # プロバイダーをキーとしてメールアドレスをマージ
          authentication.provider => authentication.uid
        }
      else
        {
          # メールアドレス以外はuidが不要なのでenabledをマージ
          authentication.provider => "enabled"
        }
      end
    end.reduce({}, :merge) # マージして1つのハッシュにする

    render json: {account: account,notices: notices}, status: :ok
  end
end
