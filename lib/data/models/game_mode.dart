enum GameMode {
  classic, fiveToJesus, timeTrial, clickGuess
}

GameMode? modeFromValue(String value) {
  if (value == 'classic') {
    return GameMode.classic;
  }

  if (value == 'five_to_jesus') {
    return GameMode.fiveToJesus;
  }

  if (value == 'time_trial') {
    return GameMode.timeTrial;
  }

  if (value == 'click_guess') {
    return GameMode.clickGuess;
  }

  return null;
}
