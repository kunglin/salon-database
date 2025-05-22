#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?\n"

SERVICE_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICE_LIST=$($PSQL "select * from services")

  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  CHOOSE_SERVICE
}

CHOOSE_SERVICE(){
  read SERVICE_ID_SELECTED

  SERVICE_ID_SELECTED_RESULT=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_ID_SELECTED_RESULT ]]
  then
    SERVICE_MENU "I could not find that service. What would you like today?"
  else
    
    echo -e "\nWhat's your phone number?"

    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"

      read CUSTOMER_NAME

      INSERT_CUSOMER_RESULT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi

    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"

    read SERVICE_TIME
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    INSERT_TIME_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

    echo -e "\nI have put you down for a $SERVICE_ID_SELECTED_RESULT at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

SERVICE_MENU
