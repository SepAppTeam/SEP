class CreateCodigos < ActiveRecord::Migration
  def change
    create_table :codigos do |t|
      t.references :estudiante, index: true
      t.string :codigo_evaluacion
      t.boolean :estado

      t.timestamps
    end
  end
end
