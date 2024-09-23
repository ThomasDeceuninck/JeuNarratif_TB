import {Component, useState, useEffect } from 'react';
import { StyleSheet, View, Text, Button, TextInput, ScrollView, FlatList } from 'react-native';
import HotePage from '../screen/hotePage';


export default function Livre_contenu(props) {

    const [bibli, setBibli] = useState(props.bibli);

    //const root = ReactDOM.createRoot(document.getElementById('contenu')); 

   // const {id_livre} = route.params;

   //const {bibli} = route.params;


  return <View>

    <Text>{bibli[0].contenu_initial}</Text>
    {!bibli[0].fin ? (
        <View>
    <Text>que faites vous ?</Text>
    <FlatList data={bibli} renderItem={({ item }) =>
    <View>
     <Button title={item.resolution} onPress={() => navigation.navigate("livre", {id_livre: item.contenu_final, start2: "Next"})}/>
     </View>  
  } />
  </View>)
  :( <View>
    <Button title="retour à la  bibliotheque" onPress={() => navigation.navigate("bibliotheque")}/>
  </View>)}

  </View>; 
}
