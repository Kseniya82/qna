class Services::Search
  ALLOW_SCOPES = %w[thinking_sphinx user comment question answer].freeze
  def call(query)
    return unless ALLOW_SCOPES.include?(query[:scope])
    query[:scope].classify.constantize.search(ThinkingSphinx::Query.escape(query[:query]))
  end
end
