import { Component } from '@angular/core';

@Component({
  selector: 'app-counter-component',
  templateUrl: './steps.component.html'
})
export class StepComponent {
  public currentCount = 0;

  public incrementCounter() {
    this.currentCount++;
  }
}
