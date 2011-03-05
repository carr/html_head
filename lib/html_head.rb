module HtmlHead
  # set the page title
  def title(title, headline = '')
    @title = title.gsub(/<\/?[^>]*>/, '')
    headline.blank? ? title : headline
  end
  
  # output the page title + charset
  def head_main(options)
    options[:charset] ||= 'utf-8'    
    
    # Prefix (leading space)
    if options[:prefix]
      prefix = options[:prefix]
    elsif options[:prefix] == false
      prefix = ''
    else
      prefix = ' '
    end

    # Separator
    unless options[:separator].blank?
      separator = options[:separator]
    else
      separator = '|'
    end

    # Suffix (trailing space)
    if options[:suffix]
      suffix = options[:suffix]
    elsif options[:suffix] == false
      suffix = ''
    else
      suffix = ' '
    end
  
    # Lowercase title?
    if options[:lowercase] == true
      @title = @title.downcase unless @title.blank?
    end
    
    # Default page title
    if @title.blank? && options[:default]
      @title = options[:default]
    end

    buffer = ""

    # Set website/page order
    if @title.blank?
      # If title is blank, return only website name
      buffer << content_tag(:title, options[:site])      
    else
      if options[:reverse] == true
        # Reverse order => "Page : Website"
        buffer << content_tag(:title, @title + prefix + separator + suffix + options[:site])
      else
        # Standard order => "Website : Page"
        buffer << content_tag(:title, options[:site] + prefix + separator + suffix + @title)
      end
    end
      
    buffer << "\n"
		buffer << tag(:meta, "http-equiv" => "Content-type", :content => "text/html; charset=#{options[:charset]}")
		buffer << csrf_meta_tag
		buffer.html_safe
  end    
    
  def meta_tag(key, value)
    tag(:meta, :name => key, :content => value)
  end
  
  def favicon(url = nil, options = {})
    url = 'favicon.ico' if url.nil?
    
    if options[:size]
      tag(:link, :href => url, :rel => :icon, :sizes => "#{options[:size]}x#{options[:size]}")      
    else
      tag(:link, :href => url, :rel => "shortcut icon", :type => "image/x-icon")
    end
  end
  
  def meta_description(data)
		raise "Meta description has [#{data.length}] characters, the max is 150" if data.length > 150 && Rails.env.development?
		meta_tag('description', data)    
  end
  
  def rss_tag(url, options = {})
    options[:title] ||= 'RSS feed'
    tag(:link, :href => url, :rel => :alternate, :type => "application/atom+xml", :title => options[:title])
  end
end