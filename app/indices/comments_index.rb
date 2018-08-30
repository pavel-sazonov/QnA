ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body

  has created_at
end
