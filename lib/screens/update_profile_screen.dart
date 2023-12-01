import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/user_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String storedName = '';
  String storedEmail = '';
  String storedRol = '';
  String storedPassword = '';
  String storedId = '';

  // api controller
  final UserApiService userApiService = UserApiService();

  // Controlador para el campo de contraseña
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable para rastrear si la contraseña es visible
  bool isNewPasswordVisible = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera los valores almacenados en SharedPreferences
    storedName = prefs.getString('name') ??
        ''; // Puedes establecer un valor predeterminado si es nulo
    storedRol = prefs.getString('rol') ?? '';
    storedEmail = prefs.getString('email') ?? '';
    storedPassword = prefs.getString('password') ?? '';
    storedId = prefs.getString('id') ?? '';

    // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    setState(() {});
  }

  Future<void> _updateUser() async {
    if (passwordController.text.isEmpty || newPasswordController.text.isEmpty) {
      // Muestra un mensaje de error si algún campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sisplau, completa tots els camps'),
        ),
      );
      return; // Sale de la función si algún campo está vacío
    }
    try {
      final responseData = await userApiService.updateUser(
        userId: storedId,
        username: storedName,
        email: storedEmail,
        password: passwordController.text,
        newPassword: newPasswordController.text,
      );

      final String password = responseData['password'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('password', password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserScreen(),
        ),
      );
    } catch (e) {
      // Maneja errores de conexión o cualquier otra excepción
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_left),
        ),
        title: const Text('Editar perfil'),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage('assets/profile_image.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromRGBO(0, 125, 204,
                            1.0), // Puedes ajustar el color según tus necesidades
                      ),
                      child: const Icon(
                        Icons.camera,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nom usuari: $storedName',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      enabled: false, // No se puede editar
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail: $storedEmail',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      enabled: false, // No se puede editar
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contrasenya',
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Cambiar la visibilidad de la contraseña
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: !isNewPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contrasenya nova',
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Cambiar la visibilidad de la contraseña
                            setState(() {
                              isNewPasswordVisible = !isNewPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 125, 204,
                              1.0), // Puedes ajustar el color según tus necesidades
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
