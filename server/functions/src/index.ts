import * as functions from 'firebase-functions';
import * as express from 'express';
import * as bodyParser from 'body-parser';
import * as admin from 'firebase-admin';
import {Timestamp,GeoPoint} from '@google-cloud/firestore'

// import routes
//import location from './routes/location';
// setup firebase
admin.initializeApp();

const firestore = admin.firestore();

// setup express app
const app = express();

// setup body-parser middleware
app.use(bodyParser.json());

//app.use('/location',location);

app.post('/location/add-batch', async (req, res) => {
    let locationColRef = firestore.collection('Location');
    let userColRef = firestore.collection('User');
    let batch = firestore.batch();
    let body = req.body;
    let lastLocation = req.body.location[0];

  body.location.forEach((e:any) => {
     let datetime = Timestamp.fromMillis(Date.parse(e.timestamp));
     let geoPoint =new GeoPoint(e.coords.latitude,e.coords.longitude);
      e.uid = body.uid;
      e.datetime = datetime;
      e.coords.geoPoint= geoPoint;
      batch.create(locationColRef.doc(),e);
  });

  lastLocation.uid =  body.uid; 
  lastLocation.datetime =  Timestamp.fromMillis(Date.parse(lastLocation.timestamp)); 
  lastLocation.coords.geoPoint= new GeoPoint(lastLocation.coords.latitude,lastLocation.coords.longitude);
  batch.update(userColRef.doc(body.uid),{'lastLocation':lastLocation});
    await batch.commit();
    res.send("ok");
});

exports.app = functions.https.onRequest(app);