import wollok.game.*
import juego.*

class Bomb inherits ObjetoVisualRemovible{
	var alcance
	var duenio
	var posicionesADesaparecer = []
	var posicionesDondeAgregarFuego = []
	
	override method spawn(){
		game.onTick(3000,"la bomba explota a los 3 segundos",{self.desaparecer()})
		super()
	}
	override method desaparecer(){
		game.removeTickEvent("la bomba explota a los 3 segundos")
		super()
		mapa.remover(position)
		self.explotar()
	}
	method explotar(){
		duenio.confirmarExplosion(self)
		self.desaparecerObjetosYAgregarFuego()
		game.sound("bomba.mp3")
	}
	
	method desaparecerObjetosYAgregarFuego(){
		posicionesDondeAgregarFuego.add(position)
		if(mapa.posicionQuePuedeSerAfectadaPorUnaBomba(position))
			posicionesADesaparecer.add(position)
			
		self.revisar(position,alcance,direccionArriba)
		self.revisar(position,alcance,direccionAbajo)
		self.revisar(position,alcance,direccionDerecha)
		self.revisar(position,alcance,direccionIzquierda)

		posicionesADesaparecer.forEach{unaPosicionAExplotar=>game.getObjectsIn(unaPosicionAExplotar).forEach{objeto => objeto.desaparecer()}}
		posicionesDondeAgregarFuego.forEach{unaPosicion=>new Fuego(position=unaPosicion).spawn()}
	}
	
	method revisar(posicion,alc,direccion){
		var posARevisar = direccion.mover(posicion)
		if(alc!=0 and !mapa.esUnaPared(posARevisar)){
				posicionesDondeAgregarFuego.add(posARevisar)
			if(mapa.posicionQuePuedeSerAfectadaPorUnaBomba(posARevisar))
				posicionesADesaparecer.add(posARevisar)
			else
				self.revisar(posARevisar,alc-1,direccion)
		}	
	}

	method efectos(metodoNoSeUsa){}
	override method image(){return "bombas.png"}
}

object direccionArriba{method mover(unaPosicion)=unaPosicion.up(1)}
object direccionAbajo{method mover(unaPosicion)=unaPosicion.down(1)}
object direccionDerecha{method mover(unaPosicion)=unaPosicion.right(1)}
object direccionIzquierda{method mover(unaPosicion)=unaPosicion.left(1)}

class Fuego inherits ObjetoVisualRemovible{
	override method spawn(){
		game.schedule(250,{self.terminarAnimacion()})
		game.addVisual(self)
	}
	override method desaparecer(){}
	method terminarAnimacion(){
		game.removeVisual(self)
	}
	method efectos(jugador){
		if (jugador.jugadorVivo())
			jugador.desaparecer()
	}
	override method image()="fuego.png"
	
}