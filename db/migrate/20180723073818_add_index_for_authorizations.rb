class AddIndexForAuthorizations < ActiveRecord::Migration[5.2]
  def change
    add_index :authorizations, %i[provider uid]
  end
end
