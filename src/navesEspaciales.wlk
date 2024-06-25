class NaveEspacial{
	var velocidad
	var direccion
	var combustible
	
	method acelerar(cuanto){ 100000.min(velocidad = velocidad + cuanto)}
	method desacelerar(cuanto){ 0.max(velocidad = velocidad - cuanto)}
	method irHaciaElSol(){ direccion = 10}
	method escaparDelSol(){direccion = -10}
	method ponerseParaleloAlSol(){direccion = 0}
	method acercarseUnPocoAlSol(){direccion = 10.min(direccion + 1)}
	method alejarseUnPocoDelSol(){direccion = -10.max (direccion - 1)}
	method prepararViaje(){
		self.cargarCombustible(3000)
		self.acelerar(5000)
	}
	method combustible() = combustible
	method cargarCombustible(litros) {combustible = combustible + litros}
	method descargarCombustible(litros) {combustible = 0.max(combustible - litros)}
	method estaTranquila(){
		return
		combustible >= 4000 and velocidad <= 12000
	}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	
	method estaRelajado(){
		return self.estaTranquila() and self.tienePocaActividad()
	}
	
	method tienePocaActividad()
}

class NavesBaliza inherits NaveEspacial {
	var baliza
	var cambioDeColor = false
	method cambiarColorDeBaliza(colorNuevo) {
		baliza = colorNuevo
		cambioDeColor = true
	} 
	method colorBaliza() = baliza
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("Verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila(){
		return super() and
		not self.colorBaliza()== "rojo"	
	// colorBaliza |="rojo"
	}
	override method escapar() {self.irHaciaElSol()}
	override method avisar(){self.cambiarColorDeBaliza("rojo")}
	override method tienePocaActividad() {
		 return not cambioDeColor
	}
}

class NavesDePasajeros inherits NaveEspacial  {
	const cantidadDePasajeros 
	var racionesDeComida = 0
	var racionesBebidas = 0
	var racionesDeComidaServida=0
	method agregarRacionesDeComida(raciones){ racionesDeComida= racionesDeComida + raciones}
	method descargarRacionesDeComida(raciones){ 0.max(racionesDeComida= racionesDeComida - raciones)}
	method agregarRacionesDeBebidas(raciones) {racionesBebidas = racionesBebidas + raciones}
	method descargarRacionesDeBebidas(raciones) {0.max(racionesBebidas = racionesBebidas - raciones)}
	method servirRacionesDeComida(raciones){
		self.descargarRacionesDeComida(raciones)
		racionesDeComidaServida = racionesDeComidaServida + raciones
	}
	
	override method prepararViaje() {
		super()
		self.agregarRacionesDeComida(cantidadDePasajeros * 4)
		self.agregarRacionesDeBebidas(cantidadDePasajeros * 6)
		self.acercarseUnPocoAlSol()
	}
	override method escapar(){
		self.acelerar(velocidad)		
	}
	override method avisar(){
		self.servirRacionesDeComida(cantidadDePasajeros)
		self.descargarRacionesDeBebidas(cantidadDePasajeros * 2)

	}
	override method tienePocaActividad(){
		return racionesDeComidaServida < 50
	}
}

class NaveDeCombate inherits NaveEspacial{
	var visible
	var misilesDesplegados
	const mensajesEmitidos =[]
	method ponerseVisible(){visible = true}
	method ponerseInvisible(){visible = false}
	method estaInvisible(){ return not visible}
	method desplegarMisiles(){misilesDesplegados = true}
	method replegarMisiles(){misilesDesplegados= false}	
	method misilesDesplegados(){return misilesDesplegados}
	method emitirMensaje(mensaje){ mensajesEmitidos.add (mensaje)}
	method mensajesEmitidos() = mensajesEmitidos
	method primerMensajeEmitido(){return mensajesEmitidos.first()}
	method ultimoMensajeEmitido(){return mensajesEmitidos.last()}
	method esEscueta(){return not mensajesEmitidos.any({m => m.size()>30})}
	method emitioMensaje(mensaje){mensajesEmitidos.contains(mensaje)}
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.desplegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method estaTranquila(){
		return
		super()
		and not self.misilesDesplegados()
	}
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()	
		}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}	
	override method tienePocaActividad(){
		return
		self.esEscueta()
	}
}

class NaveHospital inherits NavesDePasajeros{
	var property quirofanosPreparados
	override method estaTranquila(){
		return
		super() and not self.quirofanosPreparados() 
	}
	override method recibirAmenaza(){
		super()
		quirofanosPreparados = true
	}
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
	override method estaTranquila(){
		return
		super() and
		not self.estaInvisible()
	}
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseVisible()
	}
}