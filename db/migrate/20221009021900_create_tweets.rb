class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.string :body
      t.integer :likes
      t.integer :retweets

      t.timestamps
    end
  end
end
