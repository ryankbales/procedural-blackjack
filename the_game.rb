require 'pry'
play_again = true
while play_again == true
  #create the deck of card_suits
  CARD_VALUES = {two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10, jack: 10, queen: 10, king: 10, ace: 11}
  card_face = ["two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king", "ace"]
  card_suits = ["hearts", "dimonds", "clubs", "spades"]
  deck = card_face.product(card_suits)

  puts "Lets play Blackjack"
  shuffled_deck = deck.shuffle

  player_cards = []
  dealer_cards = []

  def deal_two_cards_each(deck, player, dealer)
    2.times do |card|
     player << deck.shift
     dealer << deck.shift
    end
  end

  def deal_player_one_card(deck, player)
    player << deck.shift
  end

  def get_hand_value(player, values)
    player_card_values = []
    player.each do |card|
      values.each do |k, v|
        if card[0] == k.to_s
          player_card_values << v
        end
      end
    end
    hand_value = 0
    player_card_values.each do |value|
      hand_value += value
    end
    return hand_value
  end

  def blackjack?(hand_value)
    if hand_value == 21
      return true
    else
      return false
    end
  end

  def bust?(hand_value)
    if hand_value > 21
      return true
    else
      return false
    end
  end

  def show_hand(hand)
    hand.each do |card|
      puts "#{card[0]} of #{card[1]}"
    end
  end

  def show_one_card(hand)
    face_up = hand.first
    puts "#{face_up[0]} of #{face_up[1]}"
  end

  def check_hand(hand_value, result)
    if blackjack?(hand_value)
      result = 'blackjack'
    elsif bust?(hand_value)
      result = 'bust'
    else
      result = false
    end
    return result
  end

  def hit_or_stay?
    puts "(H)it or (S)tay?"
    response = gets.chomp.downcase
    if response == "h"
      return true
    elsif response == "s"
      return false
    else
      puts "Please enter 'h' or 's'"
      hit_or_stay?
    end
  end

  def player_plays(players_hand, hand_value, deck, values=CARD_VALUES)
    puts "You have #{hand_value}"
    play_status = true
    while play_status
      play = hit_or_stay?
      if play
        player_hand = deal_player_one_card(deck, players_hand)
        hand_value = get_hand_value(player_hand, values)
        hand_status = check_hand(hand_value, play_status)
        case hand_status
        when 'blackjack'
          show_hand(player_hand)
          puts "#{hand_value}!, you have Blackjack!  Dealers turn."
          play_status = false
          return hand_value
        when 'bust'
          show_hand(player_hand)
          puts "You have #{hand_value}, you Bust :("
          play_status = false
          hand_value = 'bust'
          return hand_value
        when hand_status == false
          player_plays(players_hand, hand_value, deck)
        end
      else
        show_hand(players_hand)
        puts "You have decided to stay with #{hand_value}, good luck!"
        return hand_value
      end
    end
  end

  def dealer_plays(dealers_hand, hand_value, deck, values=CARD_VALUES)
    puts "Dealer has #{hand_value}"
    show_hand(dealers_hand)
    if (hand_value.is_a?(Integer))
      if (hand_value < 17)
        begin
          deal_player_one_card(deck, dealers_hand)
          puts "Dealers cards:"
          show_hand(dealers_hand)
          hand_value = get_hand_value(player, values)
          puts "Dealer has #{hand_value}"
        end if (hand_value >= 17 && !blackjack?(hand_value) && !bust?(hand_value)) || (blackjack?(hand_value)) || (bust?(hand_value))
        return hand_value
      elsif hand_value == 17
        puts "Dealer has 17 and stays"
        return hand_value
      elsif (hand_value > 17) && (hand_value < 21)
        puts "Dealers cards:"
        show_hand(dealers_hand)
        puts "Dealer stays at #{hand_value}"
        return hand_value
      end
    else
      puts "Dealers cards:"
      show_hand(dealers_hand)
      hand_value = 'bust'
      return hand_value
    end
  end

  def play_again?
    puts "Would you like to play again? Yes or No?"
    response = gets.chomp.downcase
    if response == "yes"
      system 'clear'
      return true
    elsif response == "no"
      system 'clear'
      return false
    else
      puts "Invalid input, please enter Yes or No?"
      play_again?
    end
  end

  #Initial deal
  deal_two_cards_each(shuffled_deck, player_cards, dealer_cards)
  player_hand_value = get_hand_value(player_cards, CARD_VALUES)
  dealer_hand_value = get_hand_value(dealer_cards, CARD_VALUES)
  #Check initial hands for blackjack or continue play
  player_has_blackjack = blackjack?(player_hand_value)
  dealer_has_blackjack = blackjack?(dealer_hand_value)

  #initial hand check
  if player_has_blackjack && !dealer_has_blackjack
    puts 'You have Blackjack! You win!'
    puts "Players cards:"
    show_hand(player_cards)
    play_again = play_again?
  elsif !player_has_blackjack && dealer_has_blackjack
    puts 'Dealer has Blackjack, you lose :('
    puts "Players cards:"
    show_hand(player_cards)
    puts "================"
    puts "Dealers face up card:"
    show_hand(player_cards)
    show_hand(dealer_cards)
    play_again = play_again?
  elsif player_has_blackjack && dealer_has_blackjack
    puts "It's a Push! You both have 21."
    puts "Players cards:"
    show_hand(player_cards)
    puts "================"
    puts "Dealers cards:"
    show_hand(dealer_cards)
    play_again = play_again?
  else
    #continued gameplay
    puts "Players cards:"
    show_hand(player_cards)
    puts "================"
    puts "Dealers face up card:"
    show_one_card(dealer_cards)

    #players turn
    player_hand_value = player_plays(player_cards, player_hand_value, shuffled_deck)

    #dealers turn
    dealer_hand_value = dealer_plays(player_cards, player_hand_value, shuffled_deck)

    #check hands
    if (player_hand_value != 'bust') && (dealer_hand_value != 'bust')
      if player_hand_value > dealer_hand_value
        puts "You have #{player_hand_value} and dealer has #{dealer_hand_value}: You Win!"
      elsif player_hand_value < dealer_hand_value
        puts "You have #{player_hand_value} and dealer has #{dealer_hand_value}: Dealer Wins!"
      else
        puts "You have #{player_hand_value} and dealer has #{dealer_hand_value}: It's a push!"
      end
    elsif (player_hand_value != 'bust') && (dealer_hand_value == 'bust')
      puts "You have #{player_hand_value} and dealer has #{dealer_hand_value}: Dealer busts, you win!"
    else
      puts "You have #{player_hand_value} and dealer has #{dealer_hand_value}: You bust, Dealer wins!"
    end
  end
  play_again = play_again?
end
