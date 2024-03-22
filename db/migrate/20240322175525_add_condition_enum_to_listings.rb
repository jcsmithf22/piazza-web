class AddConditionEnumToListings < ActiveRecord::Migration[7.1]
  def change
    create_enum :listing_condition, %i[mint near_mint used defective]

    change_table :listings do |t|
      t.enum :condition, enum_type: :listing_condition
    end
  end
end
