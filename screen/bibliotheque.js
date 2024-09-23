import {Component, useState, useEffect } from 'react';
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { StyleSheet, View, Text, Button,GoalInput, TextInput, ScrollView, FlatList, GoalItem , TouchableHighlight} from 'react-native';


export default function Bibliotheque({navigation}) {

  //const [courseGoals, setCourseGoals] = useState([]); 
  //const sampleData = [{id: 0, text: "zero"},{id: 1, text: "premier"},{id: 2, text: "deuxieme"}];

  //function addGoalHandler() {
  //  console.log(enteredGoalText);
  //};

  const [bibli, setBibli] = useState([])
  const [loading, setloading] = useState(true)
  const [text, onChangeText] = useState('');



  useEffect(() => {
    getBibli('http://localhost:3001/bibli');
    console.log(bibli);
  }, []);


  function getBibli(api) {
    console.log(api);
    fetch(api)
      .then((response) => response.json())
      .then((json) => setBibli(json))
      .catch((error) => console.error(error))
      .finally(() => setloading(false))
      console.log(bibli)
  }

  function onSubmitEdit() {
    console.log(text);
  }
  


  return (
    <View style={styles.appContainer}>
      <View style={styles.container2}>
        <Button title="host Page" onPress={() => navigation.navigate("hotePage")}/>
      </View>
      <View style={styles.container2}>
        <Button title="Créer une histoire" onPress={() => navigation.navigate("creation")}/>
      </View>
      <TextInput style={styles.input} onChangeText={onChangeText} value={text}  onSubmitEditing={onSubmitEdit()} />
        <Text onPress={getBibli('http://localhost:3001/biblititre/'+text)}></Text>
        {loading ? (<Text>Loading ...</Text>) : (
        <FlatList data={bibli} renderItem={({ item }) =>
        <View style={styles.container}>
         <Button  title={'\"'+item.titre+'\" créé par \"'+item.auteur+'\"   tags: '+item.tags} onPress={() => navigation.navigate("livre", {id_livre: item.id, start2: "Start"})}/>
         </View>
      
      } />
      )}  
    </View>
  );
}

//      <Text>{bibli ? bibli : 'There is no merchant data available'}</Text>
//         return <GoalItem text={item.titre+' '+item.auteur+' '+item.tags} onPress={navigation.navigate("hotePage")} id={item.titre}/>;

/* */


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
    container2: {
      padding: 10,
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
      margin: 3,
    },
    input: {
      height: 40,
      margin: 12,
      borderWidth: 1,
      padding: 10,
    },
  });