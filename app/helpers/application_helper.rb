module ApplicationHelper
  class MyCustomLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def link(text, target, attributes = {})
      li_attrs = attributes.delete(:li_attrs) || {}

      link = super text, target, attributes.merge('data-remote' => true)

      tag(:li, link, {class: 'paginate_button'}.merge(li_attrs))
    end

    def gap
      # text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
      text = '&hellip;' # "…"
      %(<li class="paginate_button disabled"><a href="">#{text}</a></li>)
    end

    def page_number(page)
      if page == current_page
        # tag(:li, page, :class => 'paginate_button disabled')
        link(page, page, :rel => rel_value(page), :li_attrs => {:class => 'paginate_button disabled'})
      else
        link(page, page, :rel => rel_value(page))
      end
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :class => classname)
      else
        link(text, page, :li_attrs => {:class => 'paginate_button previous disabled'})
        # tag(:li, text, :class => 'paginate_button previous disabled')
      end
    end

  end

  def class_if(cls, check, opts = {})
    check && !check.blank? ? opts.update({ class: [opts[:class], cls].compact.join(' ') }) : opts
  end

  def active_on_page(url)
    if current_page?(url)
      "class=active"
    end
  end

  def active_on_pages(*urls)
    if urls.any? {|url| current_page?(url)}
      "class=active"
    end
  end

  def active_class_on_prefix(url)
    if request.original_fullpath.starts_with?(url)
      "active"
    else
      ""
    end
  end

  def active_class_on_pages(*urls)
    if urls.any? {|url| current_page?(url)}
      "active"
    else
      ""
    end
  end

  def show_flash
    [:notice, :error, :alert].map {|type|
      klass = {notice: 'callout-info', error: 'callout-danger', alert: 'callout-danger'}[type]
      next unless flash[type]
      content_tag(:div, class: "callout #{klass}") {
        content_tag(:p) {
          Array(flash[type]).join('<br>').html_safe
        }
      }
    }.join.html_safe
  end

  def show_flash_in_section
    [:notice, :error, :alert].map {|type|
      next unless flash[type]
      render("shared/flash", flash_type: type, flash_header: flash[type])
    }.join.html_safe
  end

  def error_on(resource, field)
    message = resource.errors[field].try :[], 0
    return if message.nil?

    if message
      if message.include?('translation missing')
        error_type = resource.errors.details[field][0][:error]
        message = I18n.translate "activerecord.errors.attributes.#{error_type}"
      end

      content_tag 'span', message, class: "help-block"
    end
  end

  def error_class(resource, field)
    message = resource.errors[field].try :[], 0

    if message
      'has-error'
    else
      ''
    end
  end

  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => MyCustomLinkRenderer, :container => false, :inner_window => 1, :outer_window => 1
    end
    super *[collection_or_options, options].compact
  end

  def sortable_th(model, attr)
    label = I18n.t "activerecord.attributes.#{model}.#{attr}" # [:ru, :activerecord, :attributes, model, attr]

    sb = params[:sort_by]
    so = params[:sort_order]

    if sb == attr.to_s
      klass = "sorting_#{so}"
      new_order = so == 'asc' ? 'desc' : 'asc'
    else
      klass = "sorting"
      new_order = 'desc'
    end


    link = url_for(params.permit!.merge('sort_by' => attr, 'sort_order' => new_order, 'page' => nil, :anchor => 'search-results'))
    a_tag = content_tag(:a, label, :href => link, "data-remote" => true)
    content_tag(:th, a_tag, class: klass)
  end

  def pagination(collection)

  end

  def sidebar_link(title, url, icon_class = '')
    render partial: "layouts/navigation/sidebar_item", locals: { url: url, title: title, icon_class: icon_class}
  end

  def sidebar_tree(title, items, top_url = "#")
    render partial: "layouts/navigation/sidebar_tree_item", locals: { title: title, items: items, top_url: "#"}
  end
end
