import { FormControl, FormGroup, Validators } from '@angular/forms';

export function createAddressForm(): FormGroup {
    return new FormGroup({
        country: new FormControl<string>('', {
            nonNullable: true,
            validators: [Validators.required, Validators.minLength(1)]
        }),
        county: new FormControl<string>('', {
            nonNullable: true,
            validators: [Validators.required, Validators.minLength(1)]
        }),
        city: new FormControl<string>('', {
            nonNullable: true,
            validators: [Validators.required, Validators.minLength(1)]
        }),
        streetAddress: new FormControl<string>('', {
            nonNullable: true,
            validators: [Validators.required, Validators.minLength(1)]
        })
    });
}
