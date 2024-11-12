import 'package:flutter/material.dart';

class segonForm extends StatefulWidget {
  const segonForm({Key? key}) : super(key: key);

  @override
  State<segonForm> createState() => _segonFormState();
}

class _segonFormState extends State<segonForm> {
  int _currentStep = 0; // Índice del paso actual en el Stepper

  // Controladores de los campos de texto para capturar los datos de usuario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  // Función para definir los pasos del Stepper
  List<Step> _getSteps() {
    return [
      // Paso 1: Información Personal
      Step(
        title: const Text('Pers.'),
        content: Column(
          children: const [
            Text(
              'Personal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Pulsa "Contact" o pulsa el botón de "Continue".'),
          ],
        ),
        isActive: _currentStep >= 0, // Activa el paso cuando el índice es mayor o igual a 0
      ),
      // Paso 2: Información de Contacto
      Step(
        title: const Text('Contact'),
        content: Column(
          children: const [
            Text(
              'Contact',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Pulsa "Upload" o pulsa el botón de "Continue".'),
          ],
        ),
        isActive: _currentStep >= 1, // Activa el paso cuando el índice es mayor o igual a 1
      ),
      // Paso 3: Subida de datos de contacto
      Step(
        title: const Text('Upload'),
        isActive: _currentStep >= 2,
        state: _currentStep == 2 ? StepState.indexed : StepState.complete,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Upload',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingrese su información de contacto a continuación.',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 16),

            // Campo de texto para ingresar el email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de texto para ingresar la dirección
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de texto para ingresar el número de móvil
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile No',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ];
  }

  // Función para avanzar al siguiente paso del Stepper o mostrar un diálogo al final
  void _continue() {
    if (_currentStep == 2) {
      // Si estamos en el último paso (Upload), mostrar un diálogo con los datos ingresados
      String email = _emailController.text.isEmpty ? 'No email entered' : _emailController.text;
      String address = _addressController.text.isEmpty ? 'No address entered' : _addressController.text;
      String mobileNo = _mobileController.text.isEmpty ? 'No mobile number entered' : _mobileController.text;

      // Mostrar el AlertDialog con los datos ingresados
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Bordes redondeados
            ),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green), // Icono de éxito
                const SizedBox(width: 8), // Espacio entre icono y título
                const Text('Submission Completed'),
              ],
            ),
            content: Text(
              'Email: $email\n'
                  'Address: $address\n'
                  'Mobile No: $mobileNo',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Si no estamos en el último paso, pasar al siguiente
      if (_currentStep < _getSteps().length - 1) {
        setState(() {
          _currentStep += 1;
        });
      }
    }
  }

  // Función para regresar al paso anterior en el Stepper
  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.horizontal, // Stepper en orientación horizontal
              currentStep: _currentStep,
              steps: _getSteps(), // Define los pasos usando _getSteps()
              onStepContinue: _continue, // Llama a _continue() cuando se presiona el botón de continuar
              onStepCancel: _cancel, // Llama a _cancel() cuando se presiona el botón de cancelar
              onStepTapped: (int step) {
                setState(() {
                  _currentStep = step; // Cambia al paso seleccionado cuando se toca
                });
              },
              // Controla la apariencia de los botones del Stepper
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('CONTINUE'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('CANCEL'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}