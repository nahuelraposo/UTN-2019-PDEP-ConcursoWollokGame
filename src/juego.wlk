import wollok.game.*
import powerUPs.*
import jugadores.*

object juego {
	var juegoIniciado = false
	method iniciar() {
		game.title("Bomberman")
		game.width(13)
		game.height(13)	
		mapa.agregarPosiciones()
		mapa.spawnearCajas()
		game.boardGround("mapaBomb.png")
		game.addVisualIn(pantallaDeInicio,game.at(0,0))
		pantallaDeInicio.iniciarAnimacion()
		keyboard.enter().onPressDo({self.empezar()})  
		game.start()
	}
	
	method jugador1ConfiguracionInicial(){
		keyboard.w().onPressDo({jugador1.subir()})
		keyboard.s().onPressDo({jugador1.bajar()})
		keyboard.a().onPressDo({jugador1.izquierda()})
		keyboard.d().onPressDo({jugador1.derecha()})
		keyboard.space().onPressDo({jugador1.ponerBomba()})
		game.addVisual(jugador1)
		game.onCollideDo(jugador1,{unPowerUp => jugador1.agarrar(unPowerUp)})
	}
	method jugador2ConfiguracionInicial(){
		keyboard.up().onPressDo({jugador2.subir()})
		keyboard.down().onPressDo({jugador2.bajar()})
		keyboard.left().onPressDo({jugador2.izquierda()})
		keyboard.right().onPressDo({jugador2.derecha()})
		keyboard.l().onPressDo({jugador2.ponerBomba()})
		jugador2.moverse(game.at(11,11))
		game.addVisual(jugador2)
		game.onCollideDo(jugador2,{unPowerUp => jugador2.agarrar(unPowerUp)})
	}
	
	method empezar(){
		game.sound("comienzo.mp3")
		if (not juegoIniciado){
			game.removeVisual(pantallaDeInicio)
			juegoIniciado = true
			self.jugador1ConfiguracionInicial()
			self.jugador2ConfiguracionInicial()
			pantallaDeInicio.terminarAnimacion()
		}
		
	}
	
	method volverAJugar(){
		mapa.posOcupadas().forEach{unaPosicion=>self.forzarDesaparicionEn(unaPosicion)}
	}
	
	method forzarDesaparicionEn(pos){
		game.getObjectsIn(pos).forEach{unObjeto=>unObjeto.forzarDesaparicion()}
	}
}

object jugador1 inherits Bomberman{
	override method image() {
		if(mirandoADerecha)
			return "bombermanizq.png"
		else
			return "bomberman.png"
	}
	
	override method desaparecer(){
		super()
		if(jugador2.jugadorVivo())
			pierde1.perder()
		else
			empate.perder()
	}
}

object jugador2 inherits Bomberman{
	override method image() {
		if(mirandoADerecha)
			return "bomberman2izq.png"
		else
			return "bomberman2.png"
	}
	
	override method desaparecer(){
		super()
		if(jugador1.jugadorVivo())
			pierde2.perder()
		else
			empate.perder()
	}
}

object mapa{
	var posProhibidas = []
	var property posOcupadas = []

	method agregar(pos){posOcupadas.add(pos)}
	method remover(pos){posOcupadas.remove(pos)}
	method posicionOcupada(pos){return posProhibidas.contains(pos) or posOcupadas.contains(pos)}
	method posicionQuePuedeSerAfectadaPorUnaBomba(pos){return posOcupadas.contains(pos) or pos == jugador1.position() or pos == jugador2.position()}
	method esUnaPared(pos){return posProhibidas.contains(pos)}
	
	method agregarPosiciones(){
		5.times{i=>
			5.times{j=>
				posProhibidas.add(game.at(i*2,j*2))
			}
		}
		11.times{k=>
			posProhibidas.add(game.at(k,0))
			posProhibidas.add(game.at(k,12))
			posProhibidas.add(game.at(0,k))
			posProhibidas.add(game.at(12,k))			
		}
	}
	
	method spawnearCajas(){
		var posicionesReservadasParaJugadores = [game.at(1,1),game.at(2,1),game.at(1,2),game.at(11,11),game.at(11,10),game.at(10,11)]
		11.times{i=>
				11.times{j=>
					var probabilidad = 1.randomUpTo(10)
					if(!posProhibidas.contains(game.at(i,j)) and probabilidad > 6 and !posicionesReservadasParaJugadores.contains(game.at(i,j)))
						new Caja(position=game.at(i,j)).spawn()
				}
			}
	}
}


class Perder{
	
	method perder(){
		game.sound("muerePj.mp3")
		game.schedule(4000,{game.addVisual(self)})
		game.schedule(4000,{game.sound("final.mp3")})
		game.schedule(11000,{game.stop()})
	}
	
	method position(){return game.origin()}
	method image()
	
}

object pierde1 inherits Perder{override method image(){return "gano2.png"}}

object pierde2 inherits Perder{override method image(){return "gano1.png"}}

object empate inherits Perder{override method image(){return "empate.png"}}

object pantallaDeInicio{
	var imagen = false
	method iniciarAnimacion(){
		game.onTick(250,"Animacion del menu",{self.cambiar()})
	}
	method terminarAnimacion(){
		game.removeTickEvent("Animacion del menu")
	}
	method cambiar(){
		if(imagen)
			imagen = false
		else
			imagen = true
	}
	method image() {
		if(imagen)
			return "menuBomb.png"
		else
			return "menuBomb1.png"
	}
}

class ObjetoVisualRemovible{
	var property position
	method spawn(){
		game.addVisual(self)
		mapa.agregar(position)
	}
	method desaparecer(){
		game.removeVisual(self)
	}
	method forzarDesaparicion(){
		game.removeVisual(self)
	}
	method image()
}



class Caja inherits ObjetoVisualRemovible{
	override method desaparecer(){
		mapa.remover(position)
		game.removeVisual(self)
		self.capazSoltarPowerUP()
	}
	method capazSoltarPowerUP(){
		var probabilidad = 1.randomUpTo(10)
		if (probabilidad <= 4)
			new UnaBombaMas(position=position).spawn()
		if (probabilidad > 7)
			new MejoraDeAlcance(position=position).spawn()
	}
	override method image(){return "caja.png"}
}