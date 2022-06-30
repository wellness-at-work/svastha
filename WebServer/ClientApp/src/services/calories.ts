import { HttpHeaders } from '@angular/common/http';

const apiVersion = "v1";

const apimSubscriptionKey = "c28eca85630a4bc095d29017f047ac30";

const headerDict = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Origin': '*',
    'api-version': apiVersion,
    'Ocp-Apim-Subscription-Key': apimSubscriptionKey
};

export const requestOptions = new HttpHeaders()
    .set('content-type', 'application/json')
    .set('accept', 'application/json')
    .set('api-version', "'" + apiVersion + "'")
    .set('Ocp-Apim-Subscription-Key', "'" + apimSubscriptionKey + "'")
    .set('Access-Control-Allow-Origin', '*');