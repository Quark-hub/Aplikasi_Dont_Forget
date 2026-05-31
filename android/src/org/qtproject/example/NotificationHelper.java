package org.qtproject.example;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;
import androidx.core.app.NotificationCompat;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.provider.Settings;

public class NotificationHelper {
    public static void requestExactAlarmPermission(Context context) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {

            AlarmManager alarmManager =
                (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

            if (!alarmManager.canScheduleExactAlarms()) {

                Intent intent =
                    new Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM);

                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

                context.startActivity(intent);
            }
        }
    }

    private static final String CHANNEL_ID = "focusflow_channel";

    // --- FUNGSI LAMA (Langsung Muncul) ---
    public static void showNotification(Context context, String title, String message) {
        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Pengingat Tugas", NotificationManager.IMPORTANCE_HIGH);
            manager.createNotificationChannel(channel);
        }

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle(title)
                .setContentText(message)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true);

        manager.notify((int) System.currentTimeMillis(), builder.build());
    }

    // --- FUNGSI BARU (Alarm Terjadwal) ---
    public static void scheduleNotification(
        Context context,
        int id,
        String title,
        String message,
        String tanggal,
        String waktu,
        long timestamp) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        Intent intent = new Intent(context, AlarmReceiver.class);

        intent.putExtra("id", id);
        intent.putExtra("title", title);
        intent.putExtra("message", message);
        intent.putExtra("tanggal", tanggal);
        intent.putExtra("waktu", waktu);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                timestamp,
                pendingIntent
            );
        } else {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                timestamp,
                pendingIntent
            );
        }
    }
}