from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from .models import User


class AuthenticationTests(APITestCase):
    """
    Test suite verifying business rules, Habeas Data compliance (Ley 1581),
    SimpleJWT token issuance, and protected /me/ profile retrieval.
    """

    def setUp(self):
        self.register_url = reverse('authentication:register')
        self.login_url = reverse('authentication:login')
        self.me_url = reverse('authentication:me')

        self.student_data = {
            'email': 'estudiante.ufps@ufps.edu.co',
            'password': 'Password123*',
            'role': User.RoleChoices.ESTUDIANTE,
            'habeas_data_consent': True,
        }

    def test_register_without_habeas_data_fails(self):
        """
        Criterio 1: Si no se marca el consentimiento de Ley 1581 de 2012,
        el sistema debe rechazar el registro con 400 Bad Request.
        """
        invalid_data = self.student_data.copy()
        invalid_data['habeas_data_consent'] = False

        response = self.client.post(self.register_url, invalid_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('habeas_data_consent', response.data)
        self.assertIn('Ley 1581 de 2012', str(response.data['habeas_data_consent'][0]))
        self.assertEqual(User.objects.count(), 0)

    def test_register_success(self):
        """
        Criterio 2: Con datos válidos y consentimiento de Habeas Data,
        el sistema registra al usuario con contraseña cifrada y retorna 201 Created.
        """
        response = self.client.post(self.register_url, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)

        user = User.objects.get(email=self.student_data['email'])
        self.assertEqual(user.role, User.RoleChoices.ESTUDIANTE)
        self.assertTrue(user.habeas_data_consent)
        self.assertIsNotNone(user.consent_date)
        # Verify password encryption
        self.assertTrue(user.check_password(self.student_data['password']))
        self.assertNotEqual(user.password, self.student_data['password'])

    def test_register_duplicate_email_fails(self):
        """
        No debe permitir registros con correos duplicados.
        """
        self.client.post(self.register_url, self.student_data, format='json')
        response = self.client.post(self.register_url, self.student_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_login_success_and_jwt_tokens(self):
        """
        Criterio 3: En /login, credenciales correctas retornan tokens access y refresh,
        además de los claims de rol y email.
        """
        User.objects.create_user(
            email=self.student_data['email'],
            password=self.student_data['password'],
            role=self.student_data['role'],
            habeas_data_consent=True
        )

        credentials = {
            'email': self.student_data['email'],
            'password': self.student_data['password'],
        }
        response = self.client.post(self.login_url, credentials, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)
        self.assertEqual(response.data['email'], self.student_data['email'])
        self.assertEqual(response.data['role'], User.RoleChoices.ESTUDIANTE)

    def test_me_endpoint_unauthorized_without_token(self):
        """
        Criterio 4 (Parte 1): Acceso anónimo a /me/ debe ser rechazado con 401 Unauthorized.
        """
        response = self.client.get(self.me_url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_me_endpoint_authorized_with_bearer_token(self):
        """
        Criterio 4 (Parte 2): Acceso autenticado con Bearer token retorna los datos
        del usuario actual (id, email, rol, habeas data).
        """
        user = User.objects.create_user(
            email=self.student_data['email'],
            password=self.student_data['password'],
            role=self.student_data['role'],
            habeas_data_consent=True
        )

        login_res = self.client.post(self.login_url, {
            'email': self.student_data['email'],
            'password': self.student_data['password'],
        }, format='json')
        token = login_res.data['access']

        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
        response = self.client.get(self.me_url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['id'], user.id)
        self.assertEqual(response.data['email'], user.email)
        self.assertEqual(response.data['role'], User.RoleChoices.ESTUDIANTE)
        self.assertTrue(response.data['habeas_data_consent'])
