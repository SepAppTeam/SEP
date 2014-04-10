class EvaluacionesController < ApplicationController

  before_action :set_evaluacion, :require_login, only: [:show, :edit, :update, :destroy]
  before_filter :require_login

  def index
    
    if params[:registro] == nil or params[:registro] <= '0' then
        params[:registro] = 3
    end
     @evaluaciones = Evaluacion.search(params[:buscar]).page(params[:page]).per_page(params[:registro].to_i).order("id")
  end

  def show
    @evaluacion = Evaluacion.find(params[:id])
    @bitacora = Bitacora.where(:estudiante_id => @evaluacion.estudiante_id).last
    if params[:format] == 'pdf' then
      output = ReceiptPdf.new(@evaluacion, view_context)
      send_data output.render, :filename => "Valoracion_Etapa_Productiva_#{@evaluacion.id}.pdf", :type => "application/pdf", 
                               :disposition => "inline"
    end
  end

  def new
    #@evaluacion = Evaluacion.new
    #@jefe = Jefe.find_by_cedula(current_user.username)
    #code = params[:code]
    #@codigo = Codigo.find_by_codigo_evaluacion(code)
  end
  
  def edit
    @evaluacion = Evaluacion.find(params[:id])
  end

  def create
    @evaluacion = Evaluacion.new(evaluacion_params)
    @evaluacion.aspectos_positivos = params[:aspectos_positivos]
    @evaluacion.aspectos_positivos_ft = params[:aspectos_positivos_ft]
    #Recuperamos el jefe desde la tabla de "users" en @jefe
    @jefe = Jefe.find_by_cedula(current_user.username)
    #Recperamos el "id" del Jefe desde @jefe
    @evaluacion.jefe_id = @jefe.id
    if @evaluacion.save then
      @codigo = Codigo.find_by_estudiante_id(@evaluacion.estudiante_id)
      @codigo.estado = false
      @codigo.save
      redirect_to :root
    end
  end

  def ventana_codigo
    
  end

  def valida_codigo
    code = params[:codigo]
    @codigo = Codigo.find_by_codigo_evaluacion(code)
    @jefe = Jefe.find_by_cedula(current_user.username)
    if @codigo then
      if @codigo.estudiante.jefe_id == @jefe.id then
        if @codigo.estado == true then
          respond_to do |format|
            format.html { render action: 'new' }
          end 
        else
          redirect_to :home, alert: 'El código ya expiró.'
        end
      else
        redirect_to :home, alert: 'Código no valido.'
      end
    else
      redirect_to :home, alert: 'El código no es valido.'
    end
  end



  def update
    @evaluacion = Evaluacion.find(params[:id])
    render :action => :edit unless @evaluacion.update_attributes(evaluacion_params)
  end

  def destroy
   @evaluacion = Evaluacion.find(params[:id])
   @evaluacion.destroy
  end


  private
    
  def set_evaluacion
    @evaluacion = Evaluacion.find(params[:id])
  end

  def evaluacion_params
    params.require(:evaluacion).permit(:estudiante_id, :jefe_id, :fecha_inicio, :fecha_fin, :fecha_evaluacion, :aspectos_positivos, :aspectos_negativos,
      :aspectospositivofactortecnico, :aspectosnegativofactortecnico, :relacionesinterpersona,
      :trabajoequipo, :solucionproblema, :cumplimiento, :organizacion, :transferenciaconocimiento,
      :mejoracontinua, :fortalecimientoocupacional, :oportunidadcalidad, :responsabilidadambiental,
      :administracionrecurso, :seguridadocupacionalindustrial, :documentacionetapaproductiva, :observacion_jefe, :observacion_aprendiz, :juicio_evaluacion, :plan_mejoramiento, :reconocimientos_especiales, :rec_especial, :aspectos_positivos_ft)
  end
end
