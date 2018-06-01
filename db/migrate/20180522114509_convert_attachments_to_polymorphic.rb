class ConvertAttachmentsToPolymorphic < ActiveRecord::Migration[5.2]
  def change
    remove_column :attachments, :question_id
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
