class Admin::ProjetsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin

  def index
    @projets = Projet.where(bailleur_id: current_user.id)
  end

  def new
    @project = Projet.new 
  end
  def create
    @project = Projet.create!(nom_du_projet: params[:nom_du_projet],
      ptf_id: params[:ptf],
      appui_id: params[:appui],
      objectif_generale_du_projet: params[:objectif_generale_du_projet],
      aspsp: params[:aspsp],
      partenaire_d_implementaton: params[:partenaire_d_implementaton],comment: params[:comment],
      debut_du_projet: params[:debut_du_projet],
      fin: params[:fin], siteweb: params[:site],
      bailleur_id: current_user.id)

    if params[:creer] == 'Enregistrer'
      @project.update(validation: nil)

    end

    for x in 1..Secteur.all.count
      if params[:"montant#{x}"].to_i > 0
        Montant.create(price: params[:"montant#{x}"],secteur_id: x, projet_id: @project.id, unite_id: params[:"unite_id#{x}"])
      end
    end

    @secteur_ids = params[:secteur_ids]
    @secteur_ids.each do |x|
      Secteurprojet.create(projet_id: @project.id , secteur_id: x.to_i)
    end
    @filiere_ids = params[:filiere_ids]
    @filiere_ids.each do |x|
      Filiereprojet.create(projet_id: @project.id , filiere_id: x.to_i)
    end
    @iga_ids = params[:iga_ids]
    @iga_ids.each do |i|
      Igaprojet.create(projet_id: @project.id , iga_id: i.to_i) 
    end

    @zone_ids = params[:zone_ids]
    @zone_ids.each do |z|
      Zoneprojet.create(projet_id: @project.id , zone_id: z.to_i)
    end


    10.times do |x|
      if params[:"checkben#{x}"] && params[:newben] != ""
        @ben = Beneficiaire.create(title: params[:"valben#{x}"])
        Benefprojet.create(projet_id: @project.id , beneficiaire_id: @ben.id)
      end
    end
    @beneficiaire_ids = params[:beneficiaire_ids]
    @beneficiaire_ids.each do |b|
      Benefprojet.create(projet_id: @project.id , beneficiaire_id: b.to_i)
    end

    @pem_ids = params[:pem_ids]
    @pem_ids.each do |p|
      Pemprojet.create(projet_id: @project.id , pem_id: p.to_i)
    end

    if @project.save
      @project.files.attach(params[:files])
      @project.picture.attach(params[:picture])
      redirect_to admin_projets_path
    else
      render :new

    end           
  end

  def show
    @projet = Projet.find(params[:id])
    if params[:creer] == 'Publier'
      @project.update(validation: false)

    end
  end

  def edit
    @projet = Projet.find(params[:id])
    @secteurprojets = Secteurprojet.where(projet_id: @projet.id)
    @sects = []
    @secteurprojets.each do |sp|
      @sects << sp.secteur
    end

    @filiereprojets = Filiereprojet.where(projet_id: @projet.id)
    @fils = []
    @filiereprojets.each do |fp|
      @fils << fp.filiere
    end

    @beneficiaireprojets = Benefprojet.where(projet_id: @projet.id)
    @bens = []
    @beneficiaireprojets.each do |bp|
      @bens << bp.beneficiaire
    end

    @igaprojets = Igaprojet.where(projet_id: @projet.id)
    @igas = []
    @igaprojets.each do |ip|
      @igas << ip.iga
    end

    @zoneprojets = Zoneprojet.where(projet_id: @projet.id)
    @zones = []
    @zoneprojets.each do |zp|
      @zones << zp.zone
    end

  end

  def update
    @projet = Projet.find(params[:id])
    if @projet.update(nom_du_projet: params[:nom_du_projet], 
     debut_du_projet: params[:debut_du_projet], objectif_generale_du_projet: params[:objectif_generale_du_projet],aspsp: params[:aspsp],partenaire_d_implementaton: params[:partenaire_d_implementaton],fin: params[:fin], appui_id: params[:appui], ptf_id: params[:ptf], 
     bailleur_id: current_user.id)

    if params[:modifier] == 'Publier' || params[:modifier] == 'Re-publier'
      @projet.update(validation: false)

    end

    @projet.secteurprojets.destroy_all
    @projet.montants.destroy_all

    for x in 0..Secteur.all.count
      if params[:"secteur_#{x}"]
        Secteurprojet.create(projet_id: @projet.id, secteur_id: params[:"secteur_#{x}"])
        Montant.create(price: params[:"montant#{params[:"secteur_#{x}"]}"],secteur_id: params[:"secteur_#{x}"], projet_id: @projet.id, unite_id: params[:"unite_id#{params[:"secteur_#{x}"]}"])
      end
    end


    @projet.filiereprojets.destroy_all
    for x in 0..Filiere.all.count-1
      if params[:"filiere_#{x}"]
        Filiereprojet.create(projet_id: @projet.id, filiere_id: params[:"filiere_#{x}"])
      end
    end


    @projet.benefprojets.destroy_all
    for x in 0..Beneficiaire.all.count-1
      if params[:"beneficiaire_#{x}"]
        Benefprojet.create(projet_id: @projet.id, beneficiaire_id: params[:"beneficiaire_#{x}"])
      end
    end

    @projet.igaprojets.destroy_all
    for x in 0..Iga.all.count-1
      if params[:"iga_#{x}"]
        Igaprojet.create(projet_id: @projet.id, iga_id: params[:"iga_#{x}"])
      end
    end


    @projet.zoneprojets.destroy_all
    for x in 0..Zone.all.count-1
      if params[:"zone_#{x}"]
        Zoneprojet.create(projet_id: @projet.id, zone_id: params[:"zone_#{x}"])
      end
    end
    redirect_to  admin_projet_path
  else
    puts 'erreur'*10
    render :edit     
  end
end

def destroy
  @projet = Projet.find(params[:id])
  @projet.destroy
  redirect_to admin_projets_path
end

private
def check_if_admin
  if current_user.is_admin == nil || current_user.is_admin == false

    flash[:danger] = "Vous n'êtes pas bailleur"
    redirect_to root_path
    
  end
end
end