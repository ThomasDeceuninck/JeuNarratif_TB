import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { StyleSheet, View, Text, Button, TextInput, ScrollView, FlatList, Modal, TouchableOpacity } from 'react-native';
import {Component, useState, useEffect } from 'react';
import Livre_contenu from "../component/livre_contenu";


export default function Livre({route, navigation}) {

  const {id_livre} = route.params;

  const [bibli, setBibli] = useState([])
  const [loading, setloading] = useState(true)
  const [start, setstart] = useState('Start')

  const [modalVisible, setModalVisible] = useState(false);
  const [infoResSpe, setInfoResSpe] = useState([null,null,null]);
  const [inputText, setInputText] = useState('');

  const [diceValue, setDiceValue] = useState(1);






  useEffect(() => {
    getBibli('http://localhost:3001/getContenu'+start+'/'+id_livre);
    console.log(bibli);
  }, []);


  function getBibli(api) {
    fetch(api)
      .then((response) => response.json())
      .then((json) => setBibli(json))
      .catch((error) => console.error(error))
      .finally(() => setloading(false))
      .finally(() => setstart('Next'))
      console.log(bibli)
  }

  function nextContenu(id_contenu, type_resolution, condition_speciale, id_contenu_bis) {
    if(type_resolution == 0){
      fetch('http://localhost:3001/getContenu'+start+'/'+id_contenu)
      .then((response) => response.json())
      .then((json) => setBibli(json))
      .catch((error) => console.error(error))
      .finally(() => setloading(false))
      .finally(() => setstart('Next'))
      console.log(bibli)
    }
    if(type_resolution == 1){
      setInfoResSpe([condition_speciale, id_contenu, id_contenu_bis]);
      setModalVisible(true);
    }
    if(type_resolution == 2){
      fetch('http://localhost:3001/getContenu'+start+'/'+id_contenu)
      .then((response) => response.json())
      .then((json) => setBibli(json))
      .catch((error) => console.error(error))
      .finally(() => setloading(false))
      .finally(() => setstart('Next'))
      console.log(bibli)
    }
  }


  const closeModal = () => {
    setModalVisible(false);
    if(diceValue<infoResSpe[0]){
      fetch('http://localhost:3001/getContenu'+start+'/'+infoResSpe[2])
      .then((response) => response.json())
      .then((json) => setBibli(json))
      .catch((error) => console.error(error))
      .finally(() => setloading(false))
      .finally(() => setstart('Next'))
      console.log(bibli)
    }
    else{
      fetch('http://localhost:3001/getContenu'+start+'/'+infoResSpe[1])
      .then((response) => response.json())
      .then((json) => setBibli(json))
      .catch((error) => console.error(error))
      .finally(() => setloading(false))
      .finally(() => setstart('Next'))
      console.log(bibli)
    }
    setInfoResSpe([null,null,null]);
    setDiceValue(1);
  };



  const rollDice = () => {
    const randomValue = Math.floor(Math.random() * 20) + 1;
    setDiceValue(randomValue);
  };





//<Text>{id_livre+' livre'}</Text>

  return (
    <View style={styles.appContainer} id="contenu">

      <Button title="coordonnée" onPress={() => console.log(bibli)}/>
      <Button title="test dice" onPress={() => nextContenu(0, 1, '10', 1)}/>

      

      {loading ? (<Text>Loading ...</Text>) : (
        
        <View>
          <Text style={styles.textCss}>{bibli[0].contenu_initial}</Text>
          <Text></Text>
          {!bibli[0].fin ? (
            <View>
              <Text style={styles.textCss2}>que faites vous ?</Text>
              <FlatList data={bibli} renderItem={({ item }) =>
                <View style={styles.container}>
                  <Button title={item.resolution} onPress={() => {nextContenu(item.contenu_final, item.type_resolution, item.condition_speciale, item.contenu_final_bis)}}/>
                </View>  
              } />
            </View>
          ):( 
            <View style={styles.endButton}>
              <Button title="retour à la  bibliotheque" onPress={() => navigation.navigate("bibliotheque")}/>
            </View>
          )}
        </View>
      )}


      <View>
        <Modal visible={modalVisible} animationType="slide">
          <View style={styles.modalContainer}>
            <View style={styles.container}>
              <View style={styles.diceContainer}>
                <Text style={styles.diceText}>Dé : {diceValue}</Text>
              </View>
              <TouchableOpacity style={styles.button} onPress={rollDice}>
                <Text style={styles.buttonText}>Lancer le dé</Text>
              </TouchableOpacity>
            </View>
            <Button title="Fermer" onPress={closeModal} />
          </View>
        </Modal>
      </View>











    </View>

  );
}


const styles = StyleSheet.create({

    appContainer:{
        padding: 50,
      },
      container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        margin: 3,
      },
      endButton:{
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        margin: 3,
        fontFamily: '#E721F5',
        
      },
      textCss:{
        fontSize: 25,
      },
      textCss2:{
        fontSize: 15,
      },
      diceContainer: {
        backgroundColor: 'lightgray',
        padding: 20,
        marginBottom: 20,
        borderRadius: 10,
      },
      diceText: {
        fontSize: 24,
        fontWeight: 'bold',
      },
      button: {
        backgroundColor: 'blue',
        paddingHorizontal: 20,
        paddingVertical: 10,
        borderRadius: 5,
      },
      buttonText: {
        color: 'white',
        fontSize: 18,
        fontWeight: 'bold',
      },
  });