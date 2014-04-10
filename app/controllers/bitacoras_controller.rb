class BitacorasController < ApplicationController
  
  before_action :set_bitacora, only: [:show, :edit, :update, :destroy]

  
  def index
    @bitacoras = Bitacora.all
  end

  def show
   @bitacora = Bitacora.find(params[:id])
  end

  def new
    @bitacora = Bitacora.new
    @estudiante = Estudiante.find_by_documento(current_user.username)
   
  end

  def edit
   @bitacora = Bitacora.find(params[:id])
  end

  def create
    @bitacora = Bitacora.new(bitacora_params)
    #Recuperamos el estudiante desde la tabla de "users" en @estudiante
    @estudiante = Estudiante.find_by_documento(current_user.username)
    #Recperamos el "id" del Estudiante desde @estudiante
    @bitacora.estudiante_id = @estudiante.id

    #Si el campo "nombreproyecto" está vacio, recuperamos el Proyecto seleccionado en @proyecto
    if @bitacora.nombreproyecto == "" then
      @proyecto = AsignarProy.find(@bitacora.asignar_proy_id)
      @bitacora.nombreproyecto = @proyecto.nombreproyecto 
    else
      #Sino el proyecto será creado con el nombre introducido en el campo "nombreproyecto"del formuario
      @proyecto = AsignarProy.create(:nombreproyecto => @bitacora.nombreproyecto, :estudiante_id => @bitacora.estudiante_id)
      @bitacora.asignar_proy_id = @proyecto.id
    end
    #Al finalizar se redirecciona al root path
    render :action => :new unless @bitacora.save
    redirect_to :home
  end

  def update
    @bitacora = Bitacora.find(params[:id])
    render :action => :edit unless @bitacora.update_attributes(bitacora_params)
     @proyecto = AsignarProy.create(:nombreproyecto => @bitacora.nombreproyecto, :estudiante_id => @bitacora.estudiante_id)
    @actividad = Actividad.create(:fecha_inicio => @bitacora.fecha_inicio,
      :nombre => @bitacora.nombre, :categoria_id => @bitacora.categoria_id,
      :actestado_id => @bitacora.actestado_id, :descripcion => @bitacora.descripcion, :objetivo => @bitacora.objetivo,
      :fecha_fin => @bitacora.fecha_fin, :asignar_proy_id => @proyecto.id)
  end

  def destroy
    @bitacora = Bitacora.find(params[:id])
    @bitacora.destroy
  end

  private

  def set_bitacora
    @bitacora = Bitacora.find(params[:id])
  end

  def bitacora_params
    params.require(:bitacora).permit(:estudiante_id, :fecha_inicio, :fecha_fin, :nombreproyecto, :categoria_id, :actestado_id, :asignar_proy_id, :actividad, :asignar_proy_id, :observaciones)
  end
end
