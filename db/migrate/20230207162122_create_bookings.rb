class CreateBookings < ActiveRecord::Migration[7.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  def change
    create_table :bookings, id: :uuid do |t|
      t.integer :passengers_count
      t.integer :identity_id
      t.text :input
      t.text :output
      t.timestamps
    end
  end
end
