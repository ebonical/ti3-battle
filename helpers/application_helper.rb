module ApplicationHelper
  def partial(template, *args)
    options = args.extract_options!
    options.merge!(layout: false)
    # Iterate over collection if provided
    if collection = options.delete(:collection)
      as = options.delete(:as) || template
      collection.inject([]) do |mem, obj|
        mem << partial(template, options.merge(locals: { as.to_sym => obj }))
      end.join("\n")
    else
      haml "_#{template}".to_sym, options
    end
  end
end
