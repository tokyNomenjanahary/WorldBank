class CreateUpdateProjets < ActiveRecord::Migration[6.0]
  def change
    create_table :update_projets do |t|
	  t.string :nom_du_projet
      t.text   :objectif_generale_du_projet
      t.text   :aspsp
      t.date   :debut_du_projet
      t.date   :fin 
      t.text   :comment
      t.string :siteweb

      t.boolean :validation, default: false
      t.belongs_to :appui, index: true
      t.belongs_to :ptf, index: true
      t.belongs_to :projet, index: true
      t.references :admin, index: true

      t.timestamps
    end
  end
end
