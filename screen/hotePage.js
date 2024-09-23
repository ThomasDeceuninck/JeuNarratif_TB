import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { StyleSheet, View, Text, Button, TextInput, ScrollView, FlatList } from 'react-native';

export default function HotePage({navigation}) {

  return (
    <View style={styles.appContainer}>
      <Text>hotePage</Text>     
    </View>
  );
}

const styles = StyleSheet.create({

    appContainer:{
        padding: 50,
      },
    container: {
      flex: 1,
      backgroundColor: '#fff',
      alignItems: 'center',
      justifyContent: 'center',
    },
  });