module AttachmentValidations
  extend ActiveSupport::Concern

  MAX_ATTACHMENT_SIZE = 10.megabytes

  included do
    validate :validate_attachments

    def validate_attachments
      self.class.attachment_names.each do |attachment_name|
        attachment = send(attachment_name)
        validate_attachment_size(attachment, attachment_name)
        validate_attachment_content_type(attachment, attachment_name)
      end
    end

    private

    def validate_attachment_size(attachment, attachment_name)
      if attachment.attached? && attachment.blob.byte_size > MAX_ATTACHMENT_SIZE
        errors.add(attachment_name, :too_large, max_size: MAX_ATTACHMENT_SIZE)
      end
    end

    def validate_attachment_content_type(attachment, attachment_name)
      if attachment.attached? && !attachment.blob.content_type.in?(%w(image/webp))
        errors.add(attachment_name, :invalid_content_type)
      end
    end
  end

  class_methods do
    def attachment_names
      @attachment_names ||= []
    end

    def has_validated_attachment(name)
      has_one_attached name
      attachment_names << name
    end
  end
end
