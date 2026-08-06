# frozen_string_literal: true

Jekyll::Hooks.register :pages, :post_render do |page|
  next unless page.output_ext == ".html"

  output = page.output
  next unless output

  baseurl = page.site.config["baseurl"].to_s.sub(%r{/$}, "")
  favicon_path = "#{baseurl}/assets/img/favicon.svg"
  custom_css_path = "#{baseurl}/assets/css/site-custom.css"

  unless output.include?(favicon_path)
    favicon_tags = <<~HTML
      <link rel="icon" type="image/svg+xml" href="#{favicon_path}">
      <link rel="shortcut icon" href="#{favicon_path}">
    HTML
    output.sub!("</head>", "#{favicon_tags}</head>")
  end

  unless output.include?(custom_css_path)
    output.sub!("</head>", %(<link rel="stylesheet" href="#{custom_css_path}">\n</head>))
  end

  output.gsub!(
    %r{\s*<a\s+href="[^"]*/feed\.xml"[^>]*>\s*<i\s+class="fa-solid\s+fa-square-rss"></i>\s*</a>}i,
    ""
  )

  page.output = output
end
