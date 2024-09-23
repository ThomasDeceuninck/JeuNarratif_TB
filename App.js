import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import Bibliotheque from './screen/bibliotheque';
import HotePage from './screen/hotePage';
import Creation from './screen/creation';
import Livre from './screen/livre';


const Stack = createNativeStackNavigator(); 

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator> 
        <Stack.Screen
          name='bibliotheque'
          component={Bibliotheque}
          options={{title: "bibliotheque"}}
        />
        <Stack.Screen
          name="hotePage"
          component={HotePage}
          options={{title: "hotePage"}}
        />
        <Stack.Screen
          name="creation"
          component={Creation}
          options={{title: "creation"}}
        />
        <Stack.Screen
          name="livre"
          component={Livre}
          options={{title: "livre"}}
        />
      </Stack.Navigator>
    </NavigationContainer>
  )
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
