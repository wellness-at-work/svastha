import { Component } from '@angular/core';

@Component({
  selector: 'app-counter-component',
  templateUrl: './sleep.component.html'
})
export class SleepComponent {
  public currentCount = 0;

  public incrementCounter() {
    this.currentCount++;
  }
}
