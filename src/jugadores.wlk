import wollok.game.*
import bomba.*
import juego.*

class Bomberman {
	var property position = game.at(1,1)
	var bombas = []
	var cantidadDeBombas = 1
	var alcance = 1 
	var mirandoADerecha = true
	var property jugadorVivo = true
	
	method subir(){self.moverse(position.up(1))}
	method bajar(){self.moverse(position.down(1))}
	method izquierda(){
		self.moverse(position.left(1))
		mirandoADerecha = false
	}
	method derecha(){
		self.moverse(position.right(1))
		mirandoADerecha = true
	}
	
	method moverse(pos){
		if(!mapa.posicionOcupada(pos))
			position = pos
	}

	method agarrar(unPowerUp){
		unPowerUp.efectos(self)
	}
	method desaparecer(){
		mapa.remover(position)
		game.removeVisual(self)
		jugadorVivo = false
	}
	method ponerBomba(){
		if(!mapa.posicionOcupada(position) and bombas.size()<cantidadDeBombas){
			var bomb = new Bomb(position=position,alcance=alcance,duenio=self)
			bombas.add(bomb)
			bomb.spawn()
		}
	}
	method confirmarExplosion(bomb){bombas.remove(bomb)}
	method alcanceDeBombas() = alcance
	method unaBombaMas() {cantidadDeBombas++}
	method mejorarAlcance(){alcance++}
	method efectos(esteMeotodoNoSeUsa){}
	method image()

}
