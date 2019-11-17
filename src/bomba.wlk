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
			
		self.revisarDer(position,alcance)
		self.revisarIzq(position,alcance)
		self.revisarAr(position,alcance)
		self.revisarAb(position,alcance)

		posicionesADesaparecer.forEach{unaPosicionAExplotar=>game.getObjectsIn(unaPosicionAExplotar).forEach{objeto => objeto.desaparecer()}}
		posicionesDondeAgregarFuego.forEach{unaPosicion=>new Fuego(position=unaPosicion).spawn()}
	}
	
	method revisarDer(posicion,alc){
		if(alc!=0 and !mapa.esUnaPared(posicion.right(1))){
				posicionesDondeAgregarFuego.add(posicion.right(1))
			if(mapa.posicionQuePuedeSerAfectadaPorUnaBomba(posicion.right(1)))
				posicionesADesaparecer.add(posicion.right(1))
			else
				self.revisarDer(posicion.right(1),alc-1)
		}
	}

	method revisarIzq(posicion,alc){
		if(alc!=0 and !mapa.esUnaPared(posicion.left(1))){
				posicionesDondeAgregarFuego.add(posicion.left(1))
			if(mapa.posicionQuePuedeSerAfectadaPorUnaBomba(posicion.left(1)))
				posicionesADesaparecer.add(posicion.left(1))
			else
				self.revisarIzq(posicion.left(1),alc-1)
		}
	}
	
	method revisarAb(posicion,alc){
		if(alc!=0 and !mapa.esUnaPared(posicion.down(1))){
				posicionesDondeAgregarFuego.add(posicion.down(1))
			if(mapa.posicionQuePuedeSerAfectadaPorUnaBomba(posicion.down(1)))
				posicionesADesaparecer.add(posicion.down(1))
			else
				self.revisarAb(posicion.down(1),alc-1)
		}
	}

	method revisarAr(posicion,alc){
		if(alc!=0 and !mapa.esUnaPared(posicion.up(1))){
				posicionesDondeAgregarFuego.add(posicion.up(1))
			if(mapa.posicionQuePuedeSerAfectadaPorUnaBomba(posicion.up(1)))
				posicionesADesaparecer.add(posicion.up(1))
			else
				self.revisarAr(posicion.up(1),alc-1)
		}
	}


	method efectos(metodoNoSeUsa){}
	override method image(){return "bombas.png"}
}

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