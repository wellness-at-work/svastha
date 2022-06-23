import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'calories',
  templateUrl: './calories.component.html'
})
export class CaloriesComponent {
  public calories: Calorie[];

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    http.get<Calorie[]>(baseUrl + 'api/SampleData/Daily').subscribe(result => {
      this.calories = result;
    }, error => console.error(error));
  }
}

interface Calorie {
  dateFormatted: string;
  id: number;
  count: number;
}
