import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class tercerForm extends StatefulWidget {
  const tercerForm({super.key});

  @override
  _tercerFormState createState() => _tercerFormState();
}

class _tercerFormState extends State<tercerForm> {
  final _formKey = GlobalKey<FormBuilderState>(); // Llave para manejar el estado del formulario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Margen alrededor del contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centra los elementos horizontalmente
          children: [
            FormBuilder(
              key: _formKey, // Asigna la llave al FormBuilder
              child: Column(
                children: [
                  // Campo de selección con chips para opciones múltiples
                  FormBuilderFilterChip(
                    name: 'chip_selection',
                    spacing: 5,
                    runSpacing: 10,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Input Chips (Filter Chip)', // Etiqueta del campo
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      ),
                    ),
                    backgroundColor: Color.fromRGBO(124, 159, 255, 75), // Color de fondo de los chips
                    selectedColor: Colors.green, // Color cuando está seleccionado
                    alignment: WrapAlignment.spaceEvenly, // Alineación de los chips
                    showCheckmark: false, // Oculta la marca de verificación en los chips
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(300), // Forma de los chips
                    ),
                    options: [
                      FormBuilderChipOption(
                        value: 'Flutter',
                        avatar: Icon(Icons.flutter_dash, color: Colors.white), // Ícono para Flutter
                      ),
                      FormBuilderChipOption(
                        value: 'Android',
                      ),
                      FormBuilderChipOption(
                        value: 'Chrome',
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Campo de interruptor (switch)
                  FormBuilderSwitch(
                    name: 'Switch',
                    title: Text('This is a switch'), // Título que describe el switch
                    initialValue: false, // Estado inicial
                    decoration: InputDecoration(
                      labelText: 'Switch',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Campo de texto con longitud máxima
                  FormBuilderTextField(
                    name: 'text_field',
                    maxLength: 15,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    decoration: const InputDecoration(
                      labelText: 'Text Field',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        borderSide: BorderSide(),
                      ),
                    ),
                    // Validador de longitud mínima y máxima
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.minLength(1),
                      FormBuilderValidators.maxLength(15),
                    ]),
                  ),
                  SizedBox(height: 16),

                  // Campo desplegable con selección de opciones
                  FormBuilderDropdown<String>(
                    name: 'dropdown_field',
                    decoration: InputDecoration(
                      labelText: 'Dropdown Field',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        borderSide: BorderSide(),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: 'Finland', child: Text('Finland')),
                      DropdownMenuItem(value: 'Spain', child: Text('Spain')),
                      DropdownMenuItem(value: 'United_kingdom', child: Text('United Kingdom')),
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    alignment: AlignmentDirectional.centerStart,
                    validator: FormBuilderValidators.required(), // Validación de campo obligatorio
                  ),
                  SizedBox(height: 16),

                  // Grupo de botones de radio
                  FormBuilderRadioGroup<String>(
                    name: 'radio_group',
                    decoration: const InputDecoration(
                      labelText: 'Radio Group Model',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    options: ['Option 1', 'Option 2', 'Option 3', 'Option 4']
                        .map((radio_group) => FormBuilderFieldOption(
                      value: radio_group,
                      child: Text(radio_group),
                    ))
                        .toList(growable: false),
                    orientation: OptionsOrientation.vertical,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.required(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Guarda y valida el formulario cuando se presiona el botón
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            // Obtiene los valores ingresados por el usuario
            String chipSelection = _formKey.currentState!.value['chip_selection'].toString();
            String switchOption = _formKey.currentState!.value['Switch'].toString();
            String textField = _formKey.currentState!.value['text_field'].toString();
            String dropdownField = _formKey.currentState!.value['dropdown_field'].toString();
            String radioGroup = _formKey.currentState!.value['radio_group'].toString();

            // Muestra la información ingresada en un AlertDialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Bordes redondeados
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green), // Icono de confirmación
                      SizedBox(width: 8),
                      Text('Submission Completed'),
                    ],
                  ),
                  content: Text(
                    // Información recopilada del formulario
                    'Technologies: $chipSelection\n'
                        'Switch: $switchOption\n'
                        'Text Field: $textField\n'
                        'Dropdown: $dropdownField\n'
                        'Radio Group: $radioGroup\n',
                    style: TextStyle(fontSize: 16),
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
          }
        },
        child: Icon(Icons.upload, color: Colors.black), // Ícono de subida en el botón flotante
      ),
    );
  }
}