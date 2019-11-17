import wollok.game.*
import juego.*

class PowerUP inherits ObjetoVisualRemovible{
	override method spawn(){
		game.addVisual(self)
	}
	method efectos(jugador){
		self.desaparecer()
		game.sound("powerUp.mp3")
	}
}

class UnaBombaMas inherits PowerUP{
	override method efectos(jugador){
		jugador.unaBombaMas()
		super(jugador)
	}
	override method image(){return "masBombas.png"}
}

class MejoraDeAlcance inherits PowerUP{
	override method efectos(jugador){
		jugador.mejorarAlcance()
		super(jugador)
	}
	override method image(){return "masAlcance.png"}
}