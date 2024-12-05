import 'package:asr_data/models/UserDetails.dart';
import 'package:asr_data/services/UserService.dart';
import 'package:flutter/material.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({Key? key}) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  int currentStep = 0;
  bool? isStudent;
  String? institution;
  String? occupation;
  bool? isAkanSpeaker;
  double? proficiencyLevel;
  String? tribe;
  String? otherTribe;
  String? gender;
  DateTime? dateOfBirth;
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController otherTribeController = TextEditingController();

  final UserDetailsService _userDetailsService = UserDetailsService();

  @override
  void dispose() {
    institutionController.dispose();
    occupationController.dispose();
    otherTribeController.dispose();
    super.dispose();
  }

  bool get canProceedStep1 => isStudent != null &&
      ((isStudent! && institution?.isNotEmpty == true) ||
          (!isStudent! && occupation?.isNotEmpty == true));

  bool get canProceedStep2 => isAkanSpeaker != null &&
      ((isAkanSpeaker! && proficiencyLevel != null) ||
          (!isAkanSpeaker! && tribe != null &&
              (tribe != 'Other' || otherTribe?.isNotEmpty == true)));

  bool get canProceedStep3 => gender != null && dateOfBirth != null &&
      dateOfBirth!.isBefore(DateTime.now()) &&
      dateOfBirth!.isAfter(DateTime.now().subtract(const Duration(days: 36500))); // Max age 100 years

  List<String> tribes = ['Akan', 'Ewe', 'Ga', 'Dagbani', 'Other'];

  void _submitSurvey() async {
    // Prepare the user details model
    UserDetailsModel userDetails = UserDetailsModel(
      institutionOccupation: isStudent! 
        ? institutionController.text 
        : occupationController.text,
      nativeLanguage: isAkanSpeaker! 
        ? 'Akan' 
        : (tribe == 'Other' ? otherTribeController.text : tribe!),
      proficiency: isAkanSpeaker! ? proficiencyLevel : null,
      gender: gender!,
      dateOfBirth: dateOfBirth!,
    );

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Submit the details
    bool success = await _userDetailsService.submitUserDetails(userDetails);

    // Remove loading indicator
    Navigator.of(context).pop();

    if (success) {
      showThankYouDialog();
    } else {
      // Show error dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit survey. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildSelectionButton(String text, bool isSelected, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.grey.withOpacity(0.8) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  Widget buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Are you a student?'),
        const SizedBox(height: 8),
        Row(
          children: [
            buildSelectionButton(
              'Yes',
              isStudent == true,
              () => setState(() {
                isStudent = true;
                occupation = null;
              }),
            ),
            const SizedBox(width: 16),
            buildSelectionButton(
              'No',
              isStudent == false,
              () => setState(() {
                isStudent = false;
                institution = null;
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isStudent == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("What institution are you currently enrolled in?"),
              const SizedBox(height: 8),
              TextField(
                controller: institutionController,
                decoration: InputDecoration(
                  labelText: 'Eg. KNUST',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => setState(() => institution = value),
              ),
            ],
          ),
        if (isStudent == false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("What is your current occupation"),
              const SizedBox(height: 8),
              TextField(
                controller: occupationController,
                decoration: InputDecoration(
                  labelText: 'Eg. Teacher',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => setState(() => occupation = value),
              ),
            ],
          ),
      ],
    );
  }

  Widget buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Are you a native Akan speaker?'),
        const SizedBox(height: 8),
        Row(
          children: [
            buildSelectionButton(
              'Yes',
              isAkanSpeaker == true,
              () => setState(() {
                isAkanSpeaker = true;
                tribe = null;
                otherTribe = null;
              }),
            ),
            const SizedBox(width: 16),
            buildSelectionButton(
              'No',
              isAkanSpeaker == false,
              () => setState(() {
                isAkanSpeaker = false;
                proficiencyLevel = null;
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isAkanSpeaker == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rate your proficiency level:'),
              Slider(
                value: proficiencyLevel ?? 1,
                min: 1,
                max: 5,
                divisions: 4,
                label: proficiencyLevel?.toString() ?? '1',
                onChanged: (value) => setState(() => proficiencyLevel = value),
              ),
            ],
          ),
        if (isAkanSpeaker == false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Select your tribe'),
                value: tribe,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: tribes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() {
                  tribe = newValue;
                  if (newValue != 'Other') otherTribe = null;
                }),
              ),
              const SizedBox(height: 16),
              if (tribe == 'Other')
                TextField(
                  controller: otherTribeController,
                  decoration: InputDecoration(
                    labelText: 'Specify tribe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => setState(() => otherTribe = value),
                ),
            ],
          ),
      ],
    );
  }

  Widget buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender:'),
        RadioListTile(
          title: const Text('Male'),
          value: 'Male',
          groupValue: gender,
          onChanged: (value) => setState(() => gender = value as String),
          activeColor: Colors.black,
        ),
        RadioListTile(
          title: const Text('Female'),
          value: 'Female',
          groupValue: gender,
          onChanged: (value) => setState(() => gender = value as String),
          activeColor: Colors.black,
        ),
        RadioListTile(
          title: const Text('I prefer not to say'),
          value: 'None',
          groupValue: gender,
          onChanged: (value) => setState(() => gender = value as String),
          activeColor: Colors.black,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              try {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 6570)), // Default to 18 years
                  firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => dateOfBirth = date);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error selecting date')),
                );
              }
            },
            child: Text(
              dateOfBirth != null
                  ? 'Date of Birth: ${dateOfBirth.toString().split(' ')[0]}'
                  : 'Select Date of Birth',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  void showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Image.asset(
          "assets/surveymodal.png",
          scale: 1,
        ),
        content: const Text('All Done! Thank you for contributing to this groundbreaking research', style: TextStyle(fontSize: 30),),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (currentStep + 1) / 3,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              ),
              const SizedBox(height: 16),
              const Text("Let's get to know you more!"),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: currentStep == 0
                      ? buildStep1()
                      : currentStep == 1
                      ? buildStep2()
                      : buildStep3(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: currentStep < 2
                      ? (currentStep == 0 && canProceedStep1 ||
                      currentStep == 1 && canProceedStep2
                      ? () => setState(() => currentStep++)
                      : null)
                      : (canProceedStep3
                      ? _submitSurvey
                      : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    currentStep < 2 ? 'Next' : 'Done',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}