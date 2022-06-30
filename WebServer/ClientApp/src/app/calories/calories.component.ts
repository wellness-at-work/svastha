import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { requestOptions } from '../../services/calories';
import * from gi

@Component({
  selector: 'calories',
  templateUrl: './calories.component.html'
})
export class CaloriesComponent {
  public calories: Calorie[];

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    http.get<Calorie[]>(`${baseUrl}api/caloriesproxy/dailyasync`, { 'headers': requestOptions }).subscribe(result => {
      this.calories = result as any;
    }, error => console.error(error));
  }
}

interface Calorie {
  dateFormatted: string;
  id: number;
  count: number;
}
