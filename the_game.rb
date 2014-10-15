=begin
  Create a deck of cards
    *value and suits
  shuffle the cards
  deal two cards to player
  deal two cards to computer

  start loop
  calculate players total
  stop loop if bust, blackjack or stay

  start loop
  calculate computers total
  always hit is less than 16, stay at 17 or higher
  stop loop

  if player stays and computer stays
  compare values

  if player busts
  computer wins

  if player stays and computer busts
  player wins
=end

require 'pry'

#create the deck of card_suits
deck_hash = {two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10, jack: 10, queen: 10, king: 10, acehigh: 11, acelow: 1}
card_face = [2, 3, 4, 5, 6, 7, 8, 9, 10, "jack", "queen", "king", "ace"]
card_suits = ["hearts", "dimonds", "clubs", "spades"]
deck = card_face.product(card_suits)

puts "Lets play Blackjack"
shuffled_deck = deck.shuffle

players_cards = []
dealer_cards = []

def deal_two_cards_each(deck, player, dealer)
  2.times do |card|
   player << deck.shift
   dealer << deck.shift
  end
end

deal_two_cards_each(shuffled_deck, players_cards, dealer_cards)
binding.pry