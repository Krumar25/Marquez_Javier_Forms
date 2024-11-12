import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class QuartForm extends StatefulWidget {
  @override
  _QuartFormState createState() => _QuartFormState();
}

class _QuartFormState extends State<QuartForm> {
  // Llave para el manejo del estado del formulario
  final _formKey = GlobalKey<FormBuilderState>();
  // Fecha seleccionada inicial
  DateTime? selectedDate;

  // Opciones para el Autocomplete
  final List<String> autocompleteOptions = [
    'Argentina', 'Australia', 'Brazil', 'Canada', 'China', 'Denmark',
    'Egypt', 'France', 'Germany', 'India', 'Italy', 'Japan',
    'Mexico', 'Netherlands', 'New Zealand', 'Norway', 'Russia',
    'South Korea', 'Spain', 'Sweden', 'United Kingdom', 'United States'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del formulario
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
          children: [
            FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save(); // Guarda el estado cada vez que cambia un valor
              },
              child: Column(
                children: <Widget>[
                  // Campo de autocompletado
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return autocompleteOptions.where((String option) {
                        return option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return FormBuilderTextField(
                        name: 'autocomplete',
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Autocomplete',
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),

                  // Selector de fecha
                  FormBuilderDateTimePicker(
                    name: 'date_picker',
                    inputType: InputType.date, // Sólo selección de fecha
                    decoration: InputDecoration(
                      labelText: 'Date Picker',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    initialValue: selectedDate,
                    format: DateFormat('yyyy-MM-dd'), // Formato de visualización de fecha
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onChanged: (date) {
                      setState(() {
                        selectedDate = date; // Actualización de fecha seleccionada
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Selector de rango de fechas
                  FormBuilderDateRangePicker(
                    name: 'date_range',
                    decoration: InputDecoration(
                      labelText: 'Select Date Range',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.close),
                    ),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    format: DateFormat('yyyy-MM-dd'),
                  ),
                  SizedBox(height: 20),

                  // Selector de hora
                  FormBuilderDateTimePicker(
                    name: 'time_picker',
                    inputType: InputType.time,
                    decoration: InputDecoration(
                      labelText: 'Time Picker',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    initialTime: TimeOfDay.now(),
                    format: DateFormat.Hm(), // Formato de hora (ej: 18:00)
                  ),
                  SizedBox(height: 16),

                  // Selector de chips con filtro
                  FormBuilderFilterChip(
                    name: 'chip_selection',
                    spacing: 5,
                    runSpacing: 10,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Input Chips (Filter Chip)',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: Color.fromRGBO(124, 159, 255, 75),
                    selectedColor: Colors.green,
                    alignment: WrapAlignment.spaceEvenly,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    options: [
                      FormBuilderChipOption(value: 'HTML'),
                      FormBuilderChipOption(value: 'CSS'),
                      FormBuilderChipOption(value: 'React'),
                      FormBuilderChipOption(value: 'Dart'),
                      FormBuilderChipOption(value: 'TypeScript'),
                      FormBuilderChipOption(value: 'Angular'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Botón flotante para enviar datos
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Guarda y valida el formulario cuando se presiona el botón
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            // Obtiene los valores ingresados por el usuario
            String autocompleteValue = _formKey.currentState!.value['autocomplete'].toString();
            String datePicker = _formKey.currentState!.value['date_picker'].toString();
            String dateRange = _formKey.currentState!.value['date_range'].toString();
            String timePicker = _formKey.currentState!.value['time_picker'].toString();
            String chipSelection = _formKey.currentState!.value['chip_selection'].toString();

            // Muestra la información en un AlertDialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Submission Completed'),
                    ],
                  ),
                  content: Text(
                    'Autocomplete: $autocompleteValue\n'
                        'Selected Date: $datePicker\n'
                        'Selected Time: $timePicker\n'
                        'Date Range: $dateRange\n'
                        'Technologies: $chipSelection',
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
        child: Icon(Icons.upload, color: Colors.black),
      ),
    );
  }
}