class Services::Search
  ALLOW_SCOPES = %w[thinking_sphinx user comment question answer].freeze
  def call(query)
    query[:scope].classify.constantize.search(query[:query])
  end
end
