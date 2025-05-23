module ApplicationHelper
  def available_topics
    Topic.ordered
  end

  def topic_roots
    Topic.ordered.roots
  end

  def title(page_header, page_description = nil)
    full_title = [
      page_description,
      page_header,
      ENV['SITE_NAME']
    ].compact.join(' :: ')

    content_for(:title) { full_title }
    content_for(:header) { page_header }
  end

  def admin_show_path(object)
    model_name = RailsAdmin::AbstractModel.new(object.class).to_param

    rails_admin.show_path(model_name: model_name, id: object.id)
  end

  def admin_edit_path(object)
    model_name = RailsAdmin::AbstractModel.new(object.class).to_param

    rails_admin.edit_path(model_name: model_name, id: object.id)
  end

  def can_see_full_notice_version?(notice)
    # Safelisted notices
    safelisted_notices = (ENV['SAFELISTED_NOTICES_FULL'] || []).split(',')
    return true if safelisted_notices.include?(notice.id.to_s)

    # Cancancan abilities
    return true if can?(:view_full_version, notice)

    # Token validation
    TokenUrl.valid?(params[:access_token], notice)
  end

  def footer_links
    ids = Comfy::Cms::Fragment.where(identifier: 'link_in_footer', boolean: true)
                              .pluck(:record_id)
    Comfy::Cms::Page.where(id: ids)
  end

  def header_links
    ids = Comfy::Cms::Fragment.where(identifier: 'link_in_header', boolean: true)
                              .pluck(:record_id)
    Comfy::Cms::Page.where(id: ids)
  end
end
