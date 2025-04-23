# ui/menu.sh - Affichage du menu dynamique selon INTERFACE_MODE

# Initialise les tableaux
declare -A MODULE_TITLES
declare -A MODULE_CATEGORIES
declare -A MODULE_AUTOMODES
MODULE_CHOICES=()

# Fonction de détection dynamique des modules
build_module_list() {
  MODULE_CHOICES=()
  local i=1
  for FILE in $(ls modules/*.sh | sort); do
    SCRIPT_NAME=$(basename "$FILE")
    MODULE_KEY="${SCRIPT_NAME%%.sh}"

    TITLE=$(grep -m1 "^# *Titre:" "$FILE" | cut -d: -f2- | xargs)
    [[ -z "$TITLE" ]] && TITLE="$SCRIPT_NAME"

    CATEGORY=$(grep -m1 "^# *Catégorie:" "$FILE" | cut -d: -f2- | xargs)
    [[ -z "$CATEGORY" ]] && CATEGORY="Autre"

    AUTO=$(grep -m1 "^# *Auto:" "$FILE" | cut -d: -f2- | xargs)
    [[ -z "$AUTO" ]] && AUTO="no"

    MODULE_TITLES["$MODULE_KEY"]="$TITLE"
    MODULE_CATEGORIES["$MODULE_KEY"]="$CATEGORY"
    MODULE_AUTOMODES["$MODULE_KEY"]="$AUTO"

    MODULE_CHOICES+=("$i" "$TITLE")
    ((i++))
  done
}

# Fonction d'affichage du menu principal
show_main_menu() {
  build_module_list

  local CHOICE
  if [[ $INTERFACE_MODE == "dialog" ]]; then
    CHOICE=$(dialog --clear --stdout --title "SetUpMyPi - Menu principal" \
      --menu "Choisis une étape :" 20 60 10 "${MODULE_CHOICES[@]}")
  else
    echo -e "\n========== Menu SetUpMyPi =========="
    for ((i=0; i<${#MODULE_CHOICES[@]}; i+=2)); do
      echo "${MODULE_CHOICES[$i]}) ${MODULE_CHOICES[$i+1]}"
    done
    read -rp "Ton choix : " CHOICE
  fi

  IDX=$((CHOICE - 1))
  MODULE_SCRIPT=$(ls modules/*.sh | sort | sed -n "${CHOICE}p")
  [[ -n "$MODULE_SCRIPT" ]] && bash "$MODULE_SCRIPT"
}


# Fonction de test sans exécution de modules (juste l'affichage)
test_menu() {
  build_module_list
  show_main_menu
}






















# Test direct depuis terminal
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  INTERFACE_MODE="text" # ou "dialog" si installé
  test_menu
fi


