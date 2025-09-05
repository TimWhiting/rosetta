import std/os/readline
import std/num/random

type player
  Bot
  Human

fun player/other(p : player): player 
  match p 
    Human -> Bot
    Bot -> Human

fun player/show(p:player) : string
  match p
    Bot   -> "bot"
    Human -> "human"

effect ctl move() : ()

fun get-move(p: player, max-tokens: int, total-tokens: int, last-choice)
  match p 
    Bot -> 
      val res = min(total-tokens, 4 - last-choice)
      println("Bot choosing " ++ res.show)
      res
    Human -> 
      fun recur()
        println("Total tokens: " ++ total-tokens.show)
        println("Choose a number of tokens between 1 and " ++ max-tokens.show)
        match readline().parse-int 
          Just(v) -> 
            if v >= 1 && v <= max-tokens then v // need narrowing here
            else 
              println("Input number not in range")
              recur()
          Nothing -> 
            println("Input not a number")
            recur()
      recur()

pub fun main()
  var tokens := 12
  var player := Human
  var last-choice := 0
  with handler
    ctl move()
      val choice = get-move(player, min(3, tokens), tokens, last-choice)
      last-choice := choice
      tokens := tokens - choice 
      if tokens == 0 then 
        println("Player " ++ player.show ++ " won!")
        Just(player)
      else
        player := player.other
        resume(())
  while {True}
    move()
  Nothing

fun analyze-nim()
  main()
fun result-nim()
  Just(Bot)