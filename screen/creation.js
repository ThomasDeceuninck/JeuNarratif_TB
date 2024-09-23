import {Component, useState, useEffect } from 'react';
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { StyleSheet, View, Text, Button, TextInput, ScrollView, FlatList, Modal, Picker, Switch, TouchableOpacity, Alert} from 'react-native';
import Draggable from 'react-native-draggable';
import Svg, { Line } from 'react-native-svg';

import React, {useRef} from 'react';
import {Animated, PanResponder} from 'react-native';
import { set } from 'react-native-reanimated';




export default function Creation({navigation}) {



  const [creationPush, setCreation] = useState([[],[]]);
  const [marqueur, setMarqueur] = useState(false);
  const [idItem, setIdItem] = useState(1);

  const [tabContenu, setTabContenu] = useState([]);
  const [link, setLink] = useState([]);

  const [modalVisible, setModalVisible] = useState(false);
  const [inputText, setInputText] = useState('');
  const [textInChange, setTextInChange] = useState(-1);

  const[linkContenu, setLinkContenu] = useState([false, -1, '', -1]);

  const [modalVisible2, setModalVisible2] = useState(false);
  const [inputTitle, setInputTitle] = useState('');
  const [inputAuteur, setInputAuteur] = useState('');

  const [selectedWords, setSelectedWords] = useState([]);
  const [selectedNumbers, setSelectedNumbers] = useState([]);
  const wordList = [
    { word: 'arcade', number: 0 },
    { word: 'fun', number: 1 },
    { word: 'horreur', number: 2 },
    { word: 'enigme', number: 3 },
    { word: 'policier', number: 4 },
    { word: 'fantasy', number: 5 },
  ];
  const [validationFin, setValidationFin] = useState(false);

  const [tabContenuContenu, setTabContenuContenu] = useState([]);
  const [tabContenuResolution, setTabContenuResolution] = useState([]);
  const [stackTri, setstackTri] = useState([]);
  const [rowContenuTab, setrowContenuTab] = useState(``);
  const [rowResolutionTab, setrowResolutionTab] = useState(``);

  const [newContenuInitial, setnewContenuInitial] = useState(0);
  const [newContenuFinal, setnewContenuFinal] = useState(0);
  const [newContenuFinalBis, setnewContenuFinalBis] = useState(0);








 // const [isEnabled, setIsEnabled] = useState(false);






  const pan = useRef(new Animated.ValueXY()).current;



  const panResponder = useRef(
    PanResponder.create({
      onMoveShouldSetPanResponder: () => true,
      onPanResponderMove: Animated.event([null, {dx: pan.x, dy: pan.y}]),
      onPanResponderRelease: () => {
        pan.extractOffset();
      },
    }),
  ).current;



  useEffect(() => {

    setTabContenu([[pan, panResponder, styles.box3, {type:true, texte:'', start:true, fin:false}, 0]]);
  }, []);


  const addContenu = (idResolution) => {
 //   return new Promise((resolve, reject) => {

      setIdItem(idItem+1);
      const newLink = [idResolution, idItem]
      setLink([...link, newLink])

      console.log('res = '+idResolution);
      const newPan = new Animated.ValueXY();
      const newPanResponder = PanResponder.create({
          onMoveShouldSetPanResponder: () => true,
          onPanResponderMove: Animated.event([null, {dx: newPan.x, dy: newPan.y}]),
          onPanResponderRelease: () => {
            newPan.extractOffset();
          },
        });

      const nouvelElement = [newPan, newPanResponder, styles.box1, {type:true, texte:'', start:false, fin:false}, idItem];
      setTabContenu([...tabContenu, nouvelElement]);
      console.log(tabContenu);
      console.log(link);
 //   });
  };


  const addResolution = (idContenu) => {

    setIdItem(idItem+1);
    const newLink = [idContenu, idItem]
    setLink([...link, newLink])

    console.log('cont = '+idContenu);
    const newPan = new Animated.ValueXY();
    const newPanResponder = PanResponder.create({
        onMoveShouldSetPanResponder: () => true,
        onPanResponderMove: Animated.event([null, {dx: newPan.x, dy: newPan.y}]),
        onPanResponderRelease: () => {
          newPan.extractOffset();
        },
      });

    const nouvelElement = [newPan, newPanResponder, styles.box2,{type:false, texte:'',contenuInitial:idContenu, typeResolution:4, conditionSpeciale:'100', contenuFinal:null, contenuFinalBis:null}, idItem, false, false, false]; // type false = resolution, le dernier est pour selected (déja un contenu final ou non), 2 eme false pour bis, 3 eme pour contenu existant
    setTabContenu([...tabContenu, nouvelElement]);
    console.log(tabContenu);
    console.log(link);
  };


  const addFin = (idContenu) => {
    console.log(idContenu);
    const updatedTabContenu = [...tabContenu];
    updatedTabContenu[idContenu][3].fin = true;
    updatedTabContenu[idContenu][2] = styles.box4;
    console.log(updatedTabContenu);
    setTabContenu(updatedTabContenu);
  }

  const addText = (idContenu) => {
    setTextInChange(idContenu);
    setInputText(tabContenu[idContenu][3].texte);
    setModalVisible(true);
  }


  const closeModal = () => {
    setModalVisible(false);
    console.log(inputText);
    const updatedTabContenu = [...tabContenu];
    updatedTabContenu[textInChange][3].texte = inputText;
    setTabContenu(updatedTabContenu);
    console.log(tabContenu);
    setTextInChange(-1);

  };


  const selectedValue = (typeResolution1, idItem1, contenuExistant, ContenuBisOrNot) => {
    if(typeResolution1 == 4){}
    else{
      if(contenuExistant){
        setLinkContenu([true, idItem1, ContenuBisOrNot, typeResolution1])
      }
      else{
        if(typeResolution1 == 0){
          const updatedTabContenu = [...tabContenu];
          updatedTabContenu[idItem1][3].typeResolution = typeResolution1;
          updatedTabContenu[idItem1][3].contenuFinal = idItem;
          updatedTabContenu[idItem1][5] = true;
          updatedTabContenu[idItem1][6] = true;
          setTabContenu(updatedTabContenu);
          addContenu(idItem1);
        }
        else{
          const updatedTabContenu = [...tabContenu];
          updatedTabContenu[idItem1][3].typeResolution = typeResolution1;
          updatedTabContenu[idItem1][3].contenuFinal = idItem;
   //       updatedTabContenu[idItem1][3].contenuFinalBis = idItem+1;
          updatedTabContenu[idItem1][5] = true;
          setTabContenu(updatedTabContenu);
          addContenu(idItem1);
   //       addContenu(idItem1);
        }
      }
    }
  }

  const addContenuBis = (idItem1, contenuExistant, ContenuBisOrNot) => {
    if(contenuExistant){
      setLinkContenu([true, idItem1, ContenuBisOrNot, -1]);
    }
    else{
      const updatedTabContenu = [...tabContenu];
      updatedTabContenu[idItem1][3].contenuFinalBis = idItem;
      updatedTabContenu[idItem1][6] = true;
      setTabContenu(updatedTabContenu);
      addContenu(idItem1);
    }

  }

  const addLink = (idContenu) => {
    const newLink = [linkContenu[1], idContenu];
    setLink([...link, newLink]);
    const updatedTabContenu = [...tabContenu];
    if(linkContenu[2] == 'first'){
      updatedTabContenu[linkContenu[1]][3].contenuFinal = idContenu;
      updatedTabContenu[linkContenu[1]][3].typeResolution = linkContenu[3];

      updatedTabContenu[linkContenu[1]][5] = true;
      if(linkContenu[3] == 0){
        updatedTabContenu[linkContenu[1]][6] = true;
      }
    }
    else{
      updatedTabContenu[linkContenu[1]][3].contenuFinalBis = idContenu;
      updatedTabContenu[linkContenu[1]][6] = true;
    }
    setLinkContenu([false, -1, '']);
    setTabContenu(updatedTabContenu);
  }


  const addValue = (itemValue1, idItem1) => {
    const updatedTabContenu = [...tabContenu];
    updatedTabContenu[idItem1][3].conditionSpeciale = itemValue1;
    setTabContenu(updatedTabContenu);
  }


  const toggleSwitch = (idItem1) => {
    console.log(idItem1);
 //   setIsEnabled(previousState => !previousState);
    const updatedTabContenu = [...tabContenu];
    console.log(updatedTabContenu[idItem1][7]);

    updatedTabContenu[idItem1][7] = !updatedTabContenu[idItem1][7];
    setTabContenu(updatedTabContenu);
    console.log(updatedTabContenu[idItem1][7]);
  }


  const submitStory = () => {
    let validation = true;
    let alert1 = false;
    let alert2 = false;
    let alert3 = false;
    for(let i=0; i<tabContenu.length; i++){

      if(tabContenu[i][3].texte == ''){
        validation = false;
        alert1 = true;
      }

      if (!tabContenu[i][3].type){
        if (!(tabContenu[i][3].typeResolution == '0' || tabContenu[i][3].typeResolution == '1' || tabContenu[i][3].typeResolution == '2')){
          validation = false;
          alert2 = true;
          console.log('1');
        }
        if (tabContenu[i][3].typeResolution == '0'){
          if(tabContenu[i][3].contenuFinal == null || tabContenu[i][3].contenuFinalBis != null){
            validation = false;
            alert2 = true;
            console.log('2');
          }
        }
        if (tabContenu[i][3].typeResolution == '2' || tabContenu[i][3].typeResolution == '1'){
          if(tabContenu[i][3].contenuFinal == null || tabContenu[i][3].contenuFinalBis == null){
            validation = false;
            alert2 = true;
            console.log('3');
          }
        }
      }

      if(tabContenu[i][3].type){
        let contenuSansFin = true;
        if(tabContenu[i][3].fin){
          contenuSansFin = false;
        }
        else{
          for(let j=0; j<tabContenu.length; j++){
            if(tabContenu[i][4] == tabContenu[j][3].contenuInitial){
              contenuSansFin = false;
            }
          }
        }
        if(contenuSansFin){
          validation = false;
          alert3 = true;
        }
      }
    }
    if(alert1){alert('certains textes ne sont pas complets');}
    if(alert2){alert('certaines résolutions ne sont liées à aucuns contenus');}
    if(alert3){alert('certains contenus ne possèdent pas de solutions');}

    if(validation){
      console.log('validé!');
      setModalVisible2(true);
      triTabRowCont(trierResolutionsEtContenus(tabContenu).contenusTries);
      triTabRowRes(trierResolutionsEtContenus(tabContenu).resolutionsTries);
    }
  }


  const closeModal2 = () => {
    if(inputTitle == ''){
      alert('cette histoire ne possède pas de titre');
    }
    else{
      if(inputAuteur == ''){
        alert('cette histoire ne possède pas d auteur');
      }
      else{
        console.log(inputTitle, inputAuteur, selectedWords, selectedNumbers);
        setValidationFin(true);
        // mettre ici la requete pour insert dans la db, tabContenu pour les contenus+resolution, selectedNumbers pour les tags de l'histoire,
        // inputTitle pour le titre, inputAuteur pour l'auteur (regarder si l'auteur existe et sinon le rajouter)
        console.log(`/postLivre/${inputTitle}/${inputAuteur}`);
   //     postLivre(`/postLivre/${inputTitle}/${inputAuteur}`);
        postLivre();
      }
    }
  }


  const trierResolutionsEtContenus = (donnees) => {
    const contenusTries = [];
    const resolutionsTries = [];
    const contenuIdMap = new Map();
  
    donnees.forEach((item, index) => {
      if (item[3].type === true) {
        // Si c'est un contenu, l'ajouter au tableau des contenus triés
        contenusTries.push({type:item[3].type, texte:item[3].texte, start:item[3].start, fin:item[3].fin});
        // Sauvegarder la correspondance entre l'ID de contenu d'origine et la nouvelle position
        contenuIdMap.set(item[4], contenusTries.length - 1);
        if(item[3].fin){
          resolutionsTries.push({texte:null, contenuInitial:item[4], typeResolution:null, contenuFinal:null, contenuFinalBis:null});
        }
      } else {
        // Si c'est une résolution, ajouter la résolution au tableau des résolutions triées
        resolutionsTries.push({texte:item[3].texte, contenuInitial:item[3].contenuInitial, typeResolution:parseInt(item[3].typeResolution), conditionSpeciale:parseInt(item[3].conditionSpeciale), contenuFinal:item[3].contenuFinal, contenuFinalBis:item[3].contenuFinalBis});
      }
    });


    resolutionsTries.forEach((resolution) => {
      if (resolution.contenuInitial !== null) {
        const nouveauContenuInitial = contenuIdMap.get(resolution.contenuInitial);
        if (nouveauContenuInitial !== undefined) {
          resolution.contenuInitial = nouveauContenuInitial;
        }
      }
  
      if (resolution.contenuFinal !== null) {
        const nouveauContenuFinal = contenuIdMap.get(resolution.contenuFinal);
        if (nouveauContenuFinal !== undefined) {
          resolution.contenuFinal = nouveauContenuFinal;
        }
      }
  
      if (resolution.contenuFinalBis !== null) {
        const nouveauContenuFinalBis = contenuIdMap.get(resolution.contenuFinalBis);
        if (nouveauContenuFinalBis !== undefined) {
          resolution.contenuFinalBis = nouveauContenuFinalBis;
        }
      }
    });
  
    setTabContenuContenu(contenusTries);
    setTabContenuResolution(resolutionsTries);
    // Retourner les tableaux des résolutions et des contenus triés, ainsi que la map des positions relatives
    console.log( resolutionsTries, contenusTries, contenuIdMap );
    return {contenusTries, resolutionsTries}
  };




  const triTabRowCont = (donneeContenu) => {
    let rowContenu = donneeContenu.map((item) =>`row(${item.type}, '${item.texte}', ${item.start}, ${item.fin})`)
    .join(", ");
    console.log(rowContenu);
    setrowContenuTab(rowContenu);
    console.log(tabContenuContenu, rowContenuTab, rowContenu)
  }


  const triTabRowRes = (donneeResolution) => {
    let rowResolution = donneeResolution.map((item) =>`row('${item.texte}', ${item.contenuInitial}, ${item.typeResolution}, ${item.conditionSpeciale ?? "null"}, ${item.contenuFinal}, ${item.contenuFinalBis ?? "null"})`)
    .join(", ");
    console.log(rowResolution);
    setrowResolutionTab(rowResolution);
    console.log(tabContenuResolution, rowResolutionTab, rowResolution)
  }

  //pour les tags
  const addWordAndNumber = (word, number) => {
    if (!selectedWords.includes(word)) {
      setSelectedWords((prevWords) => [...prevWords, word]);
      setSelectedNumbers((prevNumbers) => [...prevNumbers, number]);
    }
    else{alert('tag déja sélectionné')};
  };

//      <Button title="addContenu" onPress={addContenu}/>
//      <Button title="addResolution" onPress={addResolution}/>






//-----------------------------------------------------------------------api-------------------------------



const postLivre = () => {
  console.log(inputAuteur, inputTitle);

  const data1 = {
    titre: inputTitle,
    auteur: inputAuteur,
    contenu: rowContenuTab,
    resolution: rowResolutionTab,
  };

  fetch(`http://localhost:3001/postLivre`, {

    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data1),
  })
    .then((response) => response.json())
    .then((responseData) => {
      console.log(responseData);
      console.log(rowContenuTab);

 /*     const data2 = {
        contenu: rowContenuTab,
      };

      // Deuxième requête pour exécuter la deuxième fonction PostgreSQL
      fetch('http://localhost:3001/postContenu', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data2),
      })
        .then((response) => response.json())
        .then((responseData) => {

          const num = responseData.result;
          console.log(num);

          const data3 = {
            num: num,
            resolution: rowResolutionTab,
          };

          // Troisième requête pour exécuter la troisième fonction PostgreSQL
          fetch('http://localhost:3001/postResolution', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(data3),
          })
            .then((response) => response.json())
            .then((responseData) => {
              // Gérez la réponse du serveur ici (résultat de la troisième fonction)
              console.log(responseData);
              Alert.alert('Succès', 'Opérations réussies !');
            })
            .catch((error) => {
              // Gérez les erreurs ici
              console.error(error);
              Alert.alert('Erreur', 'Une erreur est survenue lors de l\'appel à la troisième fonction.');
            });
        })
        .catch((error) => {
          // Gérez les erreurs ici
          console.error(error);
          Alert.alert('Erreur', 'Une erreur est survenue lors de l\'appel à la deuxième fonction.');
        });*/
    })
    .catch((error) => {
      // Gérez les erreurs ici
      console.error(error);
      Alert.alert('Erreur', 'Une erreur est survenue lors de l\'appel à la première fonction.');
    });
};



/*
      <Button title="tri" onPress={() => trierResolutionsEtContenus(tabContenu)}/>
      <Button title="triCont" onPress={() => triTabRowCont(trierResolutionsEtContenus(tabContenu).contenusTries)}/>
      <Button title="triRes" onPress={() => triTabRowRes(trierResolutionsEtContenus(tabContenu).resolutionsTries)}/>
*/


  return (
    <View>

      <Button title="coordonnée" onPress={() => console.log(tabContenu, tabContenuContenu, tabContenuResolution, rowContenuTab, rowResolutionTab, trierResolutionsEtContenus(tabContenu).contenusTries)}/>
      <Button title='créer l histoire' onPress={submitStory}/>



      <View style={styles.container}>

        <View style={styles.overlay}>
        {tabContenu.map((item) =>(
          <View>
            <Animated.View
              style={{
                transform: [{translateX: item[0].x}, {translateY: item[0].y}],
              }}
              {...item[1].panHandlers}>
              <View style={item[2]}>
                {item[3].type ? (
                  <View>
                    {linkContenu[0] ? (
                      <Button title='link me' onPress={()=>addLink(item[4])}/>
                    ):(
                      <View>
                        {item[3].fin ? (
                          <View>
                            <Button title='text' onPress={()=>addText(item[4])}/>
                            <Text>{item[3].texte}</Text>
                          </View>
                        ):(                
                          <View>
                            <Button title="addresolution" onPress={()=>addResolution(item[4])}/>
                            <Button title='text' onPress={()=>addText(item[4])}/>
                            {item[4]==0 ? (
                              <View></View>
                            ):(
                              <Button title="fin" onPress={()=>addFin(item[4])}/>
                            )}
                            <Text>{item[3].texte}</Text>
                          </View>
                        )}
                      </View>
                    )}
                  </View>
                ):(
                  <View>
                    {item[5]&&item[6] ? (
                      <View>
                        {item[3].typeResolution=='1' ? (
                          <View>
                            <Picker
                              selectedValue={item[3].conditionSpeciale}
                              onValueChange={(itemValue, itemIndex) => addValue(itemValue, item[4])}
                              style={styles.picker}
                            >
                              <Picker.Item label="choisir une valeur de dé" value='100' />
                              <Picker.Item label="1" value='1' />
                              <Picker.Item label="2" value='2' />
                              <Picker.Item label="3" value='3' />
                              <Picker.Item label="4" value='4' />
                              <Picker.Item label="5" value='5' />
                              <Picker.Item label="6" value='6' />
                              <Picker.Item label="7" value='7' />
                              <Picker.Item label="8" value='8' />
                              <Picker.Item label="9" value='9' />
                              <Picker.Item label="10" value='10' />
                              <Picker.Item label="11" value='11' />
                              <Picker.Item label="12" value='12' />
                              <Picker.Item label="13" value='13' />
                              <Picker.Item label="14" value='14' />
                              <Picker.Item label="15" value='15' />
                              <Picker.Item label="16" value='16' />
                              <Picker.Item label="17" value='17' />
                              <Picker.Item label="18" value='18' />
                              <Picker.Item label="19" value='19' />
                              <Picker.Item label="20" value='20' />
                            </Picker>
                            <Button title='text' onPress={()=>addText(item[4])}/>
                            <Text>{item[3].texte}</Text>
                          </View>
                        ):(
                          <View>
                            {item[3].typeResolution=='2' ? (
                              <View>
                                <Picker
                                  selectedValue={item[3].conditionSpeciale}
                                  onValueChange={(itemValue, itemIndex) => addValue(itemValue, item[4])}
                                  style={styles.picker}
                                >
                                  <Picker.Item label="choisir un jeton" value='100' />
                                  <Picker.Item label="1" value='1' />
                                  <Picker.Item label="2" value='2' />
                                  <Picker.Item label="3" value='3' />
                                  <Picker.Item label="4" value='4' />
                                </Picker>
                                <Button title='text' onPress={()=>addText(item[4])}/>
                                <Text>{item[3].texte}</Text>
                              </View>
                            ):(
                              <View>
                                <Button title='text' onPress={()=>addText(item[4])}/>
                                <Text>{item[3].texte}</Text>
                              </View>
                            )}
                          </View>
                        )}
                      </View>
                    ):(
                      <View>
                        {item[5] ? (
                          <View>
                            <Button title='addcontenuBis' onPress={()=>addContenuBis(item[4], item[7], 'bis')}/>
                            <Text>contenu deja existant : {item[7] ? 'Oui' : 'Non'}</Text>
                            <Switch
                              trackColor={{ false: '#767577', true: '#81b0ff' }}
                              thumbColor={item[7] ? '#f5dd4b' : '#f4f3f4'}
                              onValueChange={()=>toggleSwitch(item[4])}
                              value={item[7]}
                            />
                            <Button title='text' onPress={()=>addText(item[4])}/>
                            <Text>{item[3].texte}</Text>
                          </View>
                        ):(
                          <View>
                            <Button title='text' onPress={()=>addText(item[4])}/>
                            <Picker
                              selectedValue={item[3].typeResolution}
                              onValueChange={(itemValue, itemIndex) => selectedValue(itemValue, item[4], item[7], 'first')}
                              style={styles.picker}
                            >
                              <Picker.Item label="choisir type" value='4' />
                              <Picker.Item label="choix simple" value='0' />
                              <Picker.Item label="lancé de dé" value='1' />
                              <Picker.Item label="jeton" value='2' />
                            </Picker>
                            <Text>contenu deja existant : {item[7] ? 'Oui' : 'Non'}</Text>
                            <Switch
                              trackColor={{ false: '#767577', true: '#81b0ff' }}
                              thumbColor={item[7] ? '#f5dd4b' : '#f4f3f4'}
                              onValueChange={()=>toggleSwitch(item[4])}
                              value={item[7]}
                            />
                            <Text>{item[3].texte}</Text>
                          </View>
                        )}
                      </View>
                    )}
                  </View>
                )}
              </View>

            </Animated.View>
          </View> 
        ))}
        </View>




        <View style={styles.block1}>
        {link.map((item)=>(
                  <View>
                  <Svg style={StyleSheet.absoluteFill}>
                    <Line
                x1={tabContenu[item[0]][0].x._offset + 50}
                y1={tabContenu[item[0]][0].y._offset + 100+tabContenu[item[0]][4]*200}
                x2={tabContenu[item[1]][0].x._offset + 50}
                y2={tabContenu[item[1]][0].y._offset + 300+tabContenu[item[0]][4]*200}
                      stroke="black"
                      strokeWidth={4}
                    />
                  </Svg>
                </View>
        ))}
        </View>


      </View>

      <View>
        <Modal visible={modalVisible} animationType="slide">
          <View style={styles.modalContainer}>
            <TextInput
              style={styles.modalInput}
              placeholder="Saisissez votre texte"
              multiline
              onChangeText={text => setInputText(text)}
            />
            <Button title="Fermer" onPress={closeModal} />
          </View>
        </Modal>
      </View>

      <View>
        <Modal visible={modalVisible2} animationType="slide">
          <View style={styles.modalContainer}>
            <View>
              {validationFin ? (
                <View>
                  <Text>félicitations! l histoire a été créée avec succès!</Text>
                  <Button title="retour à la  bibliotheque" onPress={() => navigation.navigate("bibliotheque")}/>
                  <Button title="coordonnée" onPress={() => console.log(pan.x._offset, pan.y._offset, tabContenu, rowContenuTab, rowResolutionTab)}/>
                </View>
              ):(
                <View>
                  <TextInput
                    style={styles.modalInput}
                    placeholder="titre"
                    multiline
                    onChangeText={text => setInputTitle(text)}
                  />
                  <TextInput
                    style={styles.modalInput}
                    placeholder="auteur"
                    multiline
                    onChangeText={text => setInputAuteur(text)}
                  />
                  <View>
                    <Text>Tableau de mots ajoutés :</Text>
                    <View>
                      {selectedWords.map((word, index) => (
                        <Text key={index}>{word}</Text>
                      ))}
                    </View>
                    <Text>Liste de mots cliquables :</Text>
                    {wordList.map((item, index) => (
                      <TouchableOpacity key={index} onPress={() => addWordAndNumber(item.word, item.number)}>
                        <Text>{item.word}</Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                  <Button title="terminer" onPress={closeModal2} />
                </View>
              )}
            </View>
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
    //  backgroundColor: '#fff',
   //   alignItems: 'center',
     // justifyContent: 'center',
      position: 'relative',
    },
    overlay: {
//      flex: 1, 
      position: 'absolute',
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      zIndex: 2,
      backgroundColor: 'rgba(0, 0, 0, 0.5)', // Couleur de fond semi-transparente
    },
    content: {
      flex: 1,
      // Autres styles pour le contenu principal
    },
    block: {
      width: 1000,
      height: 5000,
      backgroundColor: 'grey',
    },
    block1: {
      flex: 1,
 //     width: 10000,
 //     height: 50000,
      zIndex: 1, // Définir un zIndex pour la vue en arrière-plan
      overflow: 'visible',
      backgroundColor: 'red',
    },
    dropzone: {
      backgroundColor: 'rgba(0, 0, 256, 0.5)',
    },
    square: {
      borderRadius: 15,
      backgroundColor: 'red',
    },
    box1: {
      height: 200,
      width: 100,
      backgroundColor: 'red',
      borderRadius: 5,
    },
    box3: {
      height: 200,
      width: 100,
      backgroundColor: 'green',
      borderRadius: 5,
    },
    box2: {
      height: 200,
      width: 100,
      backgroundColor: 'blue',
      borderRadius: 5,
    },
    box4: {
      height: 200,
      width: 100,
      backgroundColor: 'turquoise',
      borderRadius: 5,
    },
    modalContainer: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      backgroundColor: 'white',
      padding: 20,
    },
    modalInput: {
      height: 150,
      borderColor: 'gray',
      borderWidth: 1,
      marginBottom: 10,
      paddingHorizontal: 10,
      textAlignVertical: 'top',
    },
  });


  /*
  num_contenu + texte_contenu + start + fin
  texte_resolution + contenu_initial (num_contenu) + type_resolution + contenu_final (+ condition_speciale + contenu_final_bis)

  [
   contenus : {
      {}
      {}
      {}
    } 
   resolutions : {
      {}
      {}
      {}
    }
  ]

      <FlatList style={styles.block} data={tabContenu} renderItem={({ item }) =>
        <View>
          <Animated.View
            style={{
              transform: [{translateX: item[0].x}, {translateY: item[0].y}],
            }}
            {...item[1].panHandlers}>
            <View style={item[2]}>
              {item[3].type ? (
                <Button title="addresolution" onPress={()=>addResolution(item[4])}/>
              ):(<Button title='addcontenu' onPress={()=>addContenu(item[4])}/>)}
            </View>

          </Animated.View>
        </View> 
      } />







                            <Button title='addcontenu' onPress={()=>addContenu(item[4])}/>







      <View style={styles.appContainer}>
        <Text>creation</Text>     
      </View>




              <Draggable x={block1Position.x} y={block1Position.y} renderSize={56} renderColor='black' renderText='A' isCircle onPressIn={()=>handleBlock1Drag}/> 




              <Svg style={StyleSheet.absoluteFill}>
          <Line
            x1={pan.x._offset}
            y1={pan.y._offset}
            x2={pan2.x._offset+50}
            y2={pan2.y._offset+50}
            stroke="black"
            strokeWidth={2}
          />
        </Svg>





      const [block1Position, setBlock1Position] = useState({ x: 200, y: 300 });


  const handleBlock1Drag = (x, y) => {
    setBlock1Position({ x, y });
    console.log(x,y);
  };


  return (
    <View >

      <Svg style={StyleSheet.absoluteFill}>
        <Line
          x1={50}
          y1={50}
          x2={75 + 50}
          y2={100 + 50}
          stroke="black"
          strokeWidth={2}
        />
      </Svg>


        <Draggable x={75} y={100} renderSize={56} renderColor='black' renderText='A' isCircle shouldReverse onShortPressRelease={()=>alert('touched!!')}/> 
        <Draggable x={block1Position.x} y={block1Position.y} renderColor='red' renderText='B' onDragRelease={(_, { x, y }) => handleBlock1Drag(_, x, y)}/>
        <Draggable/>
        <Draggable x={50} y={50}>
          <Button title="host Page" onPress={() => navigation.navigate("hotePage")}/>
        </Draggable>

    </View>
  );

















        <View>
        <Animated.View
          style={{
            transform: [{translateX: panTab[0].x}, {translateY: panTab[0].y}],
          }}
          {...panResponder.panHandlers}>
          <View style={styles.box}/>
        </Animated.View>
      </View>

      <View>
        <Animated.View
          style={{
            transform: [{translateX: pan3.x}, {translateY: pan3.y}],
          }}
          {...panResponder3.panHandlers}>
          <View style={styles.box3}/>
        </Animated.View>
      </View>

      <View>
        <Animated.View
          style={{
            transform: [{translateX: pan2.x}, {translateY: pan2.y}],
          }}
          {...panResponder2.panHandlers}>
          <View style={styles.box2}>
            <Button title="coord" onPress={() => setMarqueur(!marqueur)}/>
          </View>
        </Animated.View>
      </View>



  const handleBlock1Drag = (_, { x0, y0 }) => {
    setBlockPosition({ x: x0, y: y0 });
    console.log(x0);
  };

  const handleBlock1Drag = (e, gestureState,) => {
    const absoluteX = gestureState.x0;
    const absoluteY = gestureState.y0;
    setBlock1Position({ absoluteX, absoluteY });
    console.log(block1Position);
  };












   [pan2, panResponder2, styles.box2,{type:false, texte:'',contenuInitial:null, typeResolution:0, contenuFinal:null}],
   [pan3, panResponder3, styles.box1, {type:true, texte:''}]




























   console.log('je passe');
    let stackTriNum = 0;
    for(let i = 0; i<tabContenu.length; i++){
      if(tabContenu[i][3].type){
        setstackTri([...stackTri, [i,i-stackTriNum]])
      }
      else{
        stackTriNum += 1;
        console.log(stackTriNum);
      }
    }

    for(let i = 0; i<tabContenu.length; i++){
      console.log('je passe boucle');

      if(tabContenu[i][3].type){
        const nouvelElement = {type:tabContenu[i][3].type, texte:tabContenu[i][3].texte, start:tabContenu[i][3].start, fin:tabContenu[i][3].fin}; // type false = resolution, le dernier est pour selected (déja un contenu final ou non), 2 eme false pour bis, 3 eme pour contenu existant
        setTabContenuContenu([...tabContenuContenu, nouvelElement]);
        console.log('je passe contenu');

      }
      else{
        console.log('je passe res');


        setnewContenuInitial(tabContenu[i][3].contenuInitial);
        setnewContenuFinal(tabContenu[i][3].contenuFinal);
        setnewContenuFinalBis(tabContenu[i][3].contenuFinalBis);


        for (let j = 0; j<stackTri.length; j++){
          if(tabContenu[i][3].contenuInitial == stackTri[j][0]){
            setnewContenuInitial(stackTri[j][1]);
          }
        }
        for (let j = 0; j<stackTri.length; j++){
          if(tabContenu[i][3].contenuFinal == stackTri[j][0]){
            setnewContenuFinal(stackTri[j][1]);
          }
        }
        for (let j = 0; j<stackTri.length; j++){
          if(tabContenu[i][3].contenuFinalBis == stackTri[j][0]){
            setnewContenuFinalBis(stackTri[j][1]);
          }
        }

        const nouvelElement = {texte:tabContenu[i][3].texte, contenuInitial:newContenuInitial, typeResolution:tabContenu[i][3].typeResolution, conditionSpeciale:parseInt(tabContenu[i][3].conditionSpeciale), contenuFinal:newContenuFinal, contenuFinalBis:newContenuFinalBis}; // type false = resolution, le dernier est pour selected (déja un contenu final ou non), 2 eme false pour bis, 3 eme pour contenu existant
        setTabContenuResolution([...tabContenuResolution, nouvelElement]);
      }
    }













const [bibli, setBibli] = useState([]);
const [loading, setloading] = useState(true)


function postLivre(api) {
  console.log(api);
  console.log('/postContenu/'+rowContenuTab);
  fetch(api)
    .then((response) => response.json())
    .then((json) => setBibli(json))
    .catch((error) => console.error(error))
    .finally(() => postContenu('/postContenu/'+rowContenuTab))
    console.log(bibli);
}

function postContenu(api) {
  const num = [];
  console.log(`/postResolution/`+rowResolutionTab+`/${num[0]}`);
  fetch(api)
    .then((response) => response.json())
    .then((json) => num.push(json))
    .catch((error) => console.error(error))
    .finally(() => postResolution(`/postResolution/`+rowResolutionTab+`/${num[0]}`))
    console.log('2 + '+num);
}

function postResolution(api) {
  fetch(api)
    .then((response) => response.json())
    .then((json) => setBibli(json))
    .catch((error) => console.error(error))
    .finally(() => setloading(false))
    console.log('dernier');
}
   */