#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -A -c"
SERVICES=$($PSQL "SELECT SERVICE_ID, NAME FROM SERVICES")
SERVICE_LIST(){
  echo -e "$1"

  while true
  do
    echo "$SERVICES" | while IFS='|' read SERVICE_ID SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done

    read SERVICE_ID_SELECTED

    SERVICE_NAME=$($PSQL "SELECT NAME FROM SERVICES WHERE SERVICE_ID=$SERVICE_ID_SELECTED")

    if [[ -n $SERVICE_NAME ]]
    then
      break
    fi

    echo -e "\nPick a REAL service of the list:"
  done
}

echo -e "\nPick a service of the list:\n"
echo "$SERVICES" | while IFS='|' read SERVICE_ID SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT NAME FROM SERVICES WHERE SERVICE_ID=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]]
then
  SERVICE_LIST "\nPick a REAL service of the list:"
fi

echo -e "\nEnter your phone:"
read CUSTOMER_PHONE
CUSTOMER_ID=$($PSQL "SELECT CUSTOMER_ID FROM CUSTOMERS WHERE PHONE='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_ID ]]
then 
  echo -e "\nEnter your name:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO CUSTOMERS(PHONE,NAME) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT CUSTOMER_ID FROM CUSTOMERS WHERE PHONE='$CUSTOMER_PHONE'")
fi

echo -e "\nEnter the service time:"
read SERVICE_TIME
INSERT_APP=$($PSQL "INSERT INTO APPOINTMENTS(SERVICE_ID,CUSTOMER_ID,TIME) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

