ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body

  has created_at
end
