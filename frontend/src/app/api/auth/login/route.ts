import { NextRequest, NextResponse } from 'next/server';

type LoginRequestBody = {
  email?: string;
  password?: string;
};

export async function POST(req: NextRequest) {
  try {
    const body = (await req.json().catch(() => ({}))) as LoginRequestBody;
    // Accept any input for mock success
    const email = body?.email || 'user@example.com';

    // Mock delay to simulate network/backend processing
    await new Promise((resolve) => setTimeout(resolve, 500));

    // Mock tokens and user payload
    const access = 'mock_access_token_eyJ0eXAiOiJKV1QiLCJhbGc';
    const refresh = 'mock_refresh_token_eyJ0eXAiOiJKV1QiLCJhbGc';
    const user = {
      id: 1,
      email,
      first_name: 'John',
      last_name: 'Doe'
    };

    const res = NextResponse.json({ access, refresh, user });
    // Set HttpOnly cookies for mock tokens and user context
    res.cookies.set('access_token', access, {
      httpOnly: false, // use presence of a non-HttpOnly mirror for demo
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 // 1 hour
    });
    res.cookies.set('refresh_token', refresh, {
      httpOnly: true,
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 * 24 * 7 // 7 days
    });
    // Non-HttpOnly for mock demo so client can read and show basic user info
    res.cookies.set('user_email', email, {
      httpOnly: false,
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 * 24 * 7
    });
    res.cookies.set('user_first_name', user.first_name, {
      httpOnly: false,
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 * 24 * 7
    });
    res.cookies.set('user_last_name', user.last_name, {
      httpOnly: false,
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 * 24 * 7
    });
    return res;
  } catch (_e) {
    return NextResponse.json({ message: 'Invalid JSON' }, { status: 400 });
  }
}
